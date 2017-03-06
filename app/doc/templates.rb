#Generic responses
=begin
  @apiDefine SuccessOk
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
=end


#Generic errors
=begin
  @apiDefine ErrorUnauthorized
  @apiErrorExample {json} Error-Response:
    HTTP/1.1 401 Unauthorized
=end

=begin
  @apiDefine ErrorBadRequest
  @apiErrorExample {json} Error-Response:
    HTTP/1.1  400 Bad Request
      {
        "some_field": [
          "can't be blank",
          "is too short (minimum is 3 characters)"
        ],
        "another_field": [
          "has already been taken"
        ]
      }
=end


#Generic Params and Headers
=begin
  @apiDefine AuthorizationHeaders
  @apiHeader (Authorization) {String} Authorization Auth token
  @apiHeaderExample {string} Authorization
    Authorization: "Token token=0fb5ea846d352890901b3cd71f962f1565e57ea1"
=end

=begin
  @apiDefine CollectionParams
  @apiParam [page] number page number
  @apiParam [page_size] number page size
  @apiParam [search_field] string name of field for searching
  @apiParam [search_value] string search value
  @apiParam [sort_by] string name of field for sorting
  @apiParam [order=asc, desc] string search order
=end


#Models
=begin
  @apiDefine User
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
        "name": "user",
        "display_name": "user",
        "email": "tt@t.com",
        "role": "user",
        "created_at": "2017-01-07T15:22:03.101Z",
        "updated_at": "2017-01-07T15:22:03.101Z"
      }
=end

=begin
  @apiDefine UserForSession
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "id": "1739f0be-971a-4874-b6a7-2de699abae04",
        "name": "admin",
        "display_name": "admin",
        "email": "t@t.com",
        "terms_accepted": true,
        "role": "admin",
        "auth_token": "b32b48fa669f4ddb9bd02d3b7e98934d",
        "token_expire_time": "2017-04-06T11:05:22.541Z",
        "created_at": "2016-12-29T07:30:04.270Z",
        "updated_at": "2016-12-29T07:30:04.270Z"
      }
=end

=begin
  @apiDefine UserList
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "collection": [
          {
            "id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
            "name": "user",
            "display_name": "user",
            "email": "tt@t.com",
            "terms_accepted": true,
            "role": "user",
            "created_at": "2017-01-07T15:22:03.101Z",
            "updated_at": "2017-01-07T15:22:03.101Z"
          },
          {
            "id": "1739f0be-971a-4874-b6a7-2de699abae04",
            "name": "admin",
            "display_name": "admin",
            "email": "t@t.com",
            "terms_accepted": true,
            "role": "admin",
            "created_at": "2016-12-29T07:30:04.270Z",
            "updated_at": "2017-03-06T13:13:39.237Z"
          }
        ]
      }
=end