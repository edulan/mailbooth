## Inbox
FIXME

### Attributes
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **id** | *integer* | unique identifier of inbox | `1` |
| **name** | *string* | name of the inbox | `"My inbox"` |
| **username** | *string* | smtp username for the inbox | `"fc97223af6917411b7c6b914eff104b024"` |
| **password** | *string* | smtp password for the inbox | `"c12b3fccb5c7a195311eb5486469"` |
| **created_at** | *date-time* | when inbox was created | `"2012-01-01T12:00:00Z"` |
| **updated_at** | *date-time* | when inbox was updated | `"2012-01-01T12:00:00Z"` |
### Inbox Create
Create a new inbox.

```
POST /inboxes
```

#### Required Parameters
| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **name** | *string* |  |  |



#### Curl Example
```bash
$ curl -n -X POST http://mailbooth.herokuapp.com/api/inboxes \
  -H "Content-Type: application/json" \
 \
  -d '{
  "name": null
}'

```


#### Response Example
```
HTTP/1.1 201 Created
```
```json
{
  "id": 1,
  "name": "My inbox",
  "username": "fc97223af6917411b7c6b914eff104b024",
  "password": "c12b3fccb5c7a195311eb5486469",
  "created_at": "2012-01-01T12:00:00Z",
  "updated_at": "2012-01-01T12:00:00Z"
}
```

### Inbox Delete
Delete an existing inbox.

```
DELETE /inboxes/{inbox_id}
```


#### Curl Example
```bash
$ curl -n -X DELETE http://mailbooth.herokuapp.com/api/inboxes/$INBOX_ID \
  -H "Content-Type: application/json" \

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": 1,
  "name": "My inbox",
  "username": "fc97223af6917411b7c6b914eff104b024",
  "password": "c12b3fccb5c7a195311eb5486469",
  "created_at": "2012-01-01T12:00:00Z",
  "updated_at": "2012-01-01T12:00:00Z"
}
```

### Inbox Info
Info for existing inbox.

```
GET /inboxes/{inbox_id}
```


#### Curl Example
```bash
$ curl -n -X GET http://mailbooth.herokuapp.com/api/inboxes/$INBOX_ID

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
{
  "id": 1,
  "name": "My inbox",
  "username": "fc97223af6917411b7c6b914eff104b024",
  "password": "c12b3fccb5c7a195311eb5486469",
  "created_at": "2012-01-01T12:00:00Z",
  "updated_at": "2012-01-01T12:00:00Z"
}
```

### Inbox List
List existing inboxes.

```
GET /inboxes
```


#### Curl Example
```bash
$ curl -n -X GET http://mailbooth.herokuapp.com/api/inboxes

```


#### Response Example
```
HTTP/1.1 200 OK
```
```json
[
  {
    "id": 1,
    "name": "My inbox",
    "username": "fc97223af6917411b7c6b914eff104b024",
    "password": "c12b3fccb5c7a195311eb5486469",
    "created_at": "2012-01-01T12:00:00Z",
    "updated_at": "2012-01-01T12:00:00Z"
  }
]
```


