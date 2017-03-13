# Technical Infrastructure for the LAK Hackathon 2017

## Jisc
_simply transcribed from the wordpress site_  

- Jisc's Learning Records Warehouse, which stores activity data in xAPI and student data in a standard format known as the [Universal Data Definitions (UDD)](https://github.com/jiscdev/analytics-udd). This is based on the HT2 Learning Locker open source product augmented to support Jisc UDD storage. You can read [an overview of Jisc's architecture](https://analytics.jiscinvolve.org/wp/2016/06/28/a-technical-look-into-learning-analytics-data-and-visualisations/), [HT2's Learning locker documentation](http://docs.learninglocker.net/statements_api/), and some [sample queries](https://github.com/jiscdev/learning-analytics/blob/master/xapi-aggregation.md). If you want to get started exploring our hackathon store, use the base URL for aggregation 

>> http://jisc.learninglocker.net/api/v1/statements/aggregate?pipeline=[]

>> and the read-only key details:

>> Key: 7d7bb0ec92cf3b98eb4b77c03fb64a92414d8d97

>> Secret: 74a4242f4fa7ec52ce179814ca13e70fcf069589

>> Basic auth: N2Q3YmIwZWM5MmNmM2I5OGViNGI3N2MwM2ZiNjRhOTI0MTRkOGQ5Nzo3NGE0MjQyZjRmYTdlYzUyY2UxNzk4MTRjYTEzZTcwZmNmMDY5NTg5

- A sample data set uploaded to the above hackathon store including student data, VLE, attendance, and library use as well as sample predictions.  Whilst the data will be generated, it will follow a similar profile to the live data set.

- Jisc’s Universal xAPI Translator, which allows data to be rapidly converted from text files into any xAPI profile, allowing easy testing of new recipes and profiles. You can upload JSON templates and tsv data to https://lakemitter.data.alpha.jisc.ac.uk/xapi using credentials supplied on the day, and they will be parsed, converted to xapi, and submitted to the hackathon store above.The xAPI Translator uses the hackathon store's write access key, which will also be available on request at the hackathon.

- Analytics Labs – a secure desktop environment, allowing creation of visualizations using Tableau. Jisc has a limited number of licenses available, and so accounts can be created on demand on the day if required!

- Sample xAPI aggregation code toolkit, showing how to aggregate xAPI and UDD data as the first step in producing visualizations.

- Access to the API and code for the Jisc student app – Study Goal, allowing experimentation with student facing services.

## Tribal Student Insight

Student Insight is a learning analytics engine and dashboard application. The API will allow access to information about students, their groups, and risk predictions. The data is all artificially generated, based on attributes used in a pilot project. Please note that there are historical prediction values but the source data is missing from the demo site, also that the "influence chart" is not active.

Site: [https://lak.studentinsight.tribalclouds.net](https://lak.studentinsight.tribalclouds.net), [API documentation](student_insight_api.md) (and Postman collection).

Three logins have been prepared for all registered participants. They take the form FirstnameLastnameXX, with hyphens removed from last-names, and where XX is "IA" (institutional administrator), "PT" (personal tutor), and "ML" (module leader). These can access the web application and the API. Each login has been associated with the email used on registration. Use the "First access" link on the login page to get a password reset email sent to this email address.

About the roles: IA - sees all data; PT - has a set of 10 personal tutees and sees no other predictions; ML - has access to predictions for students on three modules.

## ICTS – University of Amsterdam

A synthetic data generator based on open source software that you can use to provision a Learning Record Store or performance/conformance test realistic infrastructure
