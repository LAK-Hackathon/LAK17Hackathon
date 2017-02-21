# Student Insight API
Please note the caveats on use of this document and the API in the section "For the avoidance of doubt...", at the end of this document.

A [Postman](https://www.getpostman.com/) collection is available in this repository : [postman collection](StudentInsight Hackathon.postman_collection.json).

Convention: {...} in a URL component, including the query string indicates where a replacement should occur, whereas {...} in a JSON example is just JSON...

## Institution Structure

The Student Insight API allows all institution structure to be accessed through the API, including periods, groups, students, and users.


### Authentication

All API requests must be authenticated, and the user must have a role with the permission to manage the desired resource, otherwise HTTP 401 code (Unauthorized) is returned.

Use Basic Authentication, in header by setting the Authorization HTTP header to `Basic BASE64(username:password)`. For example, to log as admin:admin:

```
Authorization: Basic YWRtaW46YWRtaW4=
```

## Endpoints

#### Endpoint - periods

##### GET api/periods

Returns a list of all periods, in reverse date order.


JSON
```javascript
[
	{
	  "_id": "2010-11",
	  "name": "2010-11",
	  "startsAt": "2010-08-01",
	  "endsAt": "2011-08-01"
	}
]
```

#### Endpoint - group_types

##### GET api/group_types

Retrieves a list of group types, ordered by *order*. The list may be filtered by the use of query string parameters:

- **availableOnly**: set to true, to exclude unused group types
- **authorizedGroupsOnly**: set to true, to include only groups explicitly assigned to the authenticated user

##### GET api/group_types/{id}

Retrieve the details of a single specified group type. The Student Insight id must be used.

##### GET api/group_types/id

Retrieve the details of a single group type, found from a database find built on the parameters included in the query. For example:

- `GET api/group_types/id?order=1`
- `GET api/group_types/id?label=Institution`

```javascript
[
	{
	  "name": "course",
	  "label": "Course",
	  "order": 4,
	  "hasGroupInstances": true,
	  "updateGroupInstancesEndDate": true
	}
]
```


#### Endpoint - groups

##### GET api/groups

Retrieves a list of groups. Filters may be applied, with the following query string parameters:

- **parent**: id of a group, in order to retrieve a list of this group's children groups
- **groupType**: id of a group type, in order to retrieve a list of groups of a particular type
- **authorizedGroupsOnly**: true, to retrieve only groups to which the user has explicit authorised access
- **per_page**: limit the number of retrieved results by pagination
- **page**: page number
- **search**: to filter by group name or external id
- **ensemble**: an ensemble id; in combination with the hideEmptyPredictions flag, filters to only groups with predictions (for this ensemble)
- **hideEmptyPredictions**: true; in combination with the ensemble flag, filters to only groups with predictions (for the specified ensemble)
- **sortField**: sort the groups by the specified field: *name* or *prediction-total* or *prediction-percentage*
- **sortOrder**: *asc* or *desc*


##### GET api/groups/{id}

Retrieves a single group's data; either the Student Insight id or the group's external id may be used.

##### GET api/groups/{id}/outcome_summary

Required query string parameter:

- **period**: the id of a period

Returns an analysis of outcomes of instances of the identified group, in the specified period, broken down by assessment class and outcome:

```javascript:
[
	{
		"_id":"Final evaluation",
		"value":{
			"1":58,
			"2:1":782,
			"2:2":651,
			"3":127,
			"O":32,
			"F":1
		}
	},
	{
		"_id":"Mid-term evaluation",
		"value":{
			"1":67,
			"2:1":519,
			"2:2":961,
			"3":257,
			"O":26,
			"F":1
		}
	}
]
```

##### GET api/groups/{id}/nomogram/{feature set id}

Retrieves a group's nomogram data. The query string parameter *ensemble_group_type* must be specified, with the id of the relevant group type.

##### GET api/groups/{id}/tags_summary

Returns a list of tags assigned to people in the group:

```javascript:
[
	{
		"tag": "Second intervention",
		"count": 5,
		"id": "5756f0b74e03ad0ca330548d"
	}, {
		"tag": "Police contact",
		"count": 1,
		"id": "56b9f641f28fd55e85b65c76"
	}
]
```

#### Endpoint - people

##### GET api/people

Gets all people data; note that, without any filters, this will return a very large amount of data, and should be used with caution.

The following filters on the query-string can be used to return a limited set of clients:

- **per_page** `GET api/people?per_page=25&page=2` returns the list of people paginated
- **page** `GET api/people?per_page=25&page=2` returns the list of people paginated
- **sortField** for sorting; can be 'prediction-percentage' or 'name'
- **sortOrder** `GET api/people?sortField=name&sortOrder=desc` returns the list of people in reverse name alphabetical order
- **user** `GET api/people?user=true` returns people who the current user is actively responsible for
- **search** `GET api/people?search={search term}` will return a list of people, substring matching on forename, surname or externalId
- **customSearch** `GET api/people?customSearch={json}` returns people with the specified custom attribute(s); the json query must be in the canonical form `{"gender":"Male"}`, and appropriately URL-encoded.
- **ensemble** Accepts a Student Insight ensemble id. For use in conjunction with the prediction-percentage ordering.
- **group** `GET api/people?group={group id}` returns people with a current instance in the specified group. The Student Insight id must be used.
- **drilldownPath** Can be used to limit to students with a current instance of a group, in the context of a specified ancestry. The path must be in the form `[-1,"{group type id}","{grandparent group id}","{parent group id}","{child group id}"]`, with one or more group ids in hierarchically-descending order.
- **customAttributes** `GET api/people?group={group id}&customAttributes={json}` returns people whose current instance of the specified group has the specified custom attributes; the json query must be in the canonical form `{"optionality":"mandatory"}`, and appropriately URL-encoded.
- **tag** `GET api/people?tag={tag id}` returns people with the specified tag. The Student Insight tag id must be used.
- **matchFeatures** `GET api/people?matchFeatures={json}` returns people with the specified feature value(s) in the prediction data; the json query must be in the canonical form `{"LEARN_DIF":"09"}`, and appropriately URL-encoded.

##### GET api/people/{id}

Gets a single person's data; either the Student Insight id or the person's external id may be used.

#### Endpoint - group_instances

##### GET api/group_instances/{id}

Fetches the data for a specified single group instances. The instance's Student Insight id must be used.

##### GET api/group_instances/id

Fetches the data for a specified single group instances. The person's id and group's id must be specified; these may be the Student Insight id or the externalId of each. Example:

```
api/group_instances/id?person=12945646&group=mod2016genetics205
```

##### GET /api/group_instances/{id}/past_predictions

Fetches a list of past predictions for a specified single group instances. The instance's Student Insight id must be used.


#### Endpoint - people responsible_for

##### GET api/tags/people/responsible_for/level_summary

Returns data prediction summaries (one per ensemble) for the students that the authenticated user is responsible for. This is used within the app to populate the dashboard screen.

```javascript:
{
	"prediction": {
		"578e1e477da9040f00cb966e": {
			"levelSummary": {
				"important": 0,
				"warning": 0,
				"success": 0,
				"none": 46
			},
			"personLevelSummary": {
				"important": 0,
				"warning": 0,
				"success": 0,
				"none": 9
			}
		},
		"578e24c07da9040f00cb96a3": {
			"levelSummary": {
				"important": 25,
				"warning": 12,
				"success": 0,
				"none": 0
			},
			"personLevelSummary": {
				"important": 6,
				"warning": 3,
				"success": 0,
				"none": 0
			}
		}
	}
}
```

#### Endpoint - people_custom_filters

##### GET api/configuration/people_custom_filters

Returns a list of custom attribute keys from the people collection; these are used in the app as available custom filters in any student listing.

```javascript:
[
	{
		"name": "age"
	}, {
		"name": "gender"
	}, {
		"name": "level"
	}, {
		"name": "phototype"
	}
]
```

#### Endpoint - people_custom_filters

##### GET api/configuration/groups_custom_filters

Returns a list of custom attribute keys from the groups collection; these are used in the app as available custom filters in any group listing.

```javascript:
[
	{
		"name": "Focus"
	}, {
		"name": "Level"
	}, {
		"name": "location"
	}
]
```

#### Endpoint - institution_level_summary

##### GET api/institution_level_summary

Returns an institution-level prediction summary. This is used internally by the app to populate the dashboard screen.

```javascript:
{
	"_id": "570e48a46fa8006a2b659f47",
	"prediction": {
		"575044ba5690bb0c00187e16": {
			"levelSummary": {
				"none": 23,
				"important": 51,
				"warning": 9,
				"success": 0
			},
			"personLevelSummary": {
				"none": 23,
				"important": 51,
				"warning": 9,
				"success": 0
			},
			"predictedAt": "2016-10-10T09:04:12.000Z",
			"customAttributes": {
				"campus": {
					"Collegiate": {
						"none": 1,
						"important": 17,
						"warning": 2,
						"success": 0
					},
					"Oakbrook": {
						"none": 11,
						"important": 11,
						"warning": 2,
						"success": 0
					},
					"City": {
						"none": 9,
						"important": 0,
						"warning": 0,
						"success": 0
					}
				}
			},
			"personCustomAttributes": {
				"campus": {
					"Collegiate": {
						"none": 1,
						"important": 17,
						"warning": 2,
						"success": 0
					},
					"Oakbrook": {
						"none": 11,
						"important": 11,
						"warning": 2,
						"success": 0
					},
					"City": {
						"none": 9,
						"important": 0,
						"warning": 0,
						"success": 0
					}
				}
			}
		}
	},
	"__v": 0
}
```

#### Endpoint - tags

##### GET api/tags/user_summary

Returns a list of tags for students that the authenticated user is responsible for and students in groups that the user is responsible for. This is used within the app to populate the dashboard screen.

```javascript:
[
	{
		"tag": "Police contact",
		"count": 1,
		"id": "56b9f641f28fd55e85b65c76"
	}, {
		"tag": "2nd intervention",
		"count": 2,
		"id": "56b9f588f28fd55e85b65c75"
	}, {
		"tag": "3rd intervention",
		"count": 3,
		"id": "56b9f575f28fd55e85b65c74"
	}
]
```

#### Endpoint - prediction_categories

##### GET api/prediction_categories

Returns a list of all prediction categories

##### GET api/prediction_categories/{id}

Retrieves a single prediction category

#### Endpoint - prediction_model_types

##### GET api/prediction_model_types

Returns a list of prediction model types.

#### Endpoint - class_labels

##### GET api/class_labels

Returns a list of class labels, including their prediction level data.

#### Endpoint - data_sets

This is the data which Student Insight uses to make its predictions.

##### GET api/data_sets

Returns a paginated list of data sets. Supported query string parameters are:

- **per_page**: used in pagination
- **page**: used in pagination
- **ids**: if a list of data set ids is supplied, only these data sets are returned

##### GET api/data_sets/{id}

Returns details of the specified data set.

##### GET api/data_sets/{id}/file_log

Returns a paginated list of file upload events for the specified data set, most recent first.

##### GET api/data_sets/{id}/columns/{column}

Fetches the distinct values present in a named column. For example if the request is *api/data_sets/580740d0d79e2c6100f50d5b&#8203;/columns/learn_dif* the returned data may be `['1', '10', '19', '90', '98', '99']`

#### Endpoint - feature_sets

Feature sets may be used to join together datasets.

##### GET api/feature_sets

Retrieves a list of feature sets. Supported query string parameters are:

- **per_page**: used in pagination
- **page**: used in pagination
- **ids**: if a list of feature set ids is supplied, only these feature sets are returned

##### GET api/feature_sets/{id}

Retrieves the detail of a single feature set

#### Endpoint - ensembles

Ensembles bring together the predictions from several featuresets to give a combined indicator of risk.

##### GET api/ensembles

Returns a list of ensembles.

##### GET api/ensembles/{ensemble id}

Returns data about a single ensemble.

##### GET api/ensembles/{ensemble id}/predictions/{prediction run id}

Returns data about a prediction run

##### GET api/ensembles/{ensemble id}/tests/{test run id}

Returns data about a test run

## For the avoidance of doubt...

Except by prior arrangement, the API is only to be used for the duration of LAK 2017.

Please note that the data is not "open data". It belongs to Tribal Group and must only be used for the activities within the LAK17 Hackathon by registered participants. Derived data may be retained for the purposes of demonstrating LAK17 Hackathon outputs, so long as the source is acknowledged. Original or derived data must not be distributed.

This document is provided without warranty and is for use by registered participants in the LAK17 Hackathon, only as described in this document. It must not be distributed other than as part of the entire LAK17Hackathon GitHub repository without permission of Tribal Group. It must not be altered. (c) Tribal Group 2017

Please contact adam.cooper@tribalgroup.com with any queries.