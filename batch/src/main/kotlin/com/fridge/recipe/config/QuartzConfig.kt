package com.fridge.recipe.config

import com.fridge.recipe.job.FoodRecipeJobDetail
import org.quartz.*
import org.quartz.spi.TriggerFiredBundle
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.context.ApplicationContext
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.scheduling.quartz.SchedulerFactoryBean
import org.springframework.scheduling.quartz.SpringBeanJobFactory

@Configuration
class QuartzConfig {

    @Bean
    fun jobFactory(applicationContext: ApplicationContext): SpringBeanJobFactory {
        val jobFactory = object : SpringBeanJobFactory() {
            override fun createJobInstance(bundle: TriggerFiredBundle): Any {
                val job = super.createJobInstance(bundle)
                applicationContext.autowireCapableBeanFactory.autowireBean(job)
                return job
            }
        }
        return jobFactory
    }

    @Bean
    fun schedulerFactoryBean(
        jobDetail: JobDetail,
        @Qualifier("foodRecipeTrigger") trigger: Trigger,
        jobFactory: SpringBeanJobFactory
    ): SchedulerFactoryBean {
        val factory = SchedulerFactoryBean()
        factory.setJobFactory(jobFactory)  // 여기서 jobFactory 설정
        factory.setJobDetails(jobDetail)
        factory.setTriggers(trigger)
        return factory
    }

    @Bean
    fun foodRecipeJobDetail(): JobDetail {
        return JobBuilder.newJob(FoodRecipeJobDetail::class.java)
            .withIdentity("foodRecipeJob", "recipeGroup")
            .storeDurably()
            .build()
    }

    @Bean
    fun foodRecipeTrigger(jobDetail: JobDetail): Trigger {
        return TriggerBuilder.newTrigger()
            .forJob(jobDetail)
            .withIdentity("foodRecipeTrigger", "recipeGroup")
            .withSchedule(CronScheduleBuilder.cronSchedule("0 15 21 * * ?"))  // 매일 새벽 3시
            .build()
    }

    @Bean
    fun foodRecipeImmediateTrigger(jobDetail: JobDetail): Trigger {
        return TriggerBuilder.newTrigger()
            .forJob(jobDetail)
            .withIdentity("foodRecipeTrigger", "recipeGroup")
            .startNow()
            .withSchedule(SimpleScheduleBuilder.simpleSchedule().withRepeatCount(0))  // 1회만 실행
            .build()
    }
}