#Generic responses
=begin
  @apiDefine SuccessOk
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
=end

=begin
  @apiDefine SuccessNoContent
  @apiErrorExample {json} Success-Response:
    HTTP/1.1 204 No Content
=end


#Generic errors
=begin
  @apiDefine ErrorUnauthorized
  @apiErrorExample {json} Error-Response:
    HTTP/1.1 401 Unauthorized
=end

=begin
  @apiDefine ErrorBadParams
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

=begin
  @apiDefine ErrorBadRequest
  @apiErrorExample {json} Error-Response:
    HTTP/1.1 400 Bad Request
=end

=begin
  @apiDefine ErrorForbidden
  @apiErrorExample {json} Error-Response:
    HTTP/1.1 403 Forbidden
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
  @apiParam [sort_order=asc, desc] string search order
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

=begin
  @apiDefine FriendInvitation
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "id": "3b9973f1-f37d-4497-bf82-8b52c8eea69b",
        "author_id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
        "recipient_id": "1739f0be-971a-4874-b6a7-2de699abae04",
        "accepted_at": null,
        "rejected_at": null,
        "canceled_at": null,
        "created_at": "2017-03-07T07:18:17.231Z",
        "updated_at": "2017-03-07T07:18:17.231Z"
      }
=end

=begin
  @apiDefine FriendInvitationList
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "collection": [
          {
            "id": "3b9973f1-f37d-4497-bf82-8b52c8eea69b",
            "author_id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
            "recipient_id": "1739f0be-971a-4874-b6a7-2de699abae04",
            "accepted_at": null,
            "rejected_at": null,
            "canceled_at": null,
            "created_at": "2017-03-07T07:18:17.231Z",
            "updated_at": "2017-03-07T07:18:17.231Z"
          }
        ]
      }
=end

=begin
  @apiDefine AuthorSnap
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "id": "56f1cb33-d853-45e9-942a-ddb384cfd56a",
        "user_id": "1739f0be-971a-4874-b6a7-2de699abae04",
        "file": {
          "url": "/uploads/snap/file/56f1cb33-d853-45e9-942a-ddb384cfd56a/Zrzut_ekranu_2016-12-21_o_20.03.02.png"
        },
        "file_type": "photo",
        "duration": 10,
        "created_at": "2017-03-07T09:51:56.582Z",
        "recipients": [
          {
            "id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
            "name": "user",
            "display_name": "user",
            "email": "tt@t.com",
            "role": "user",
            "created_at": "2017-01-07T15:22:03.101Z",
            "updated_at": "2017-01-07T15:22:03.101Z"
          }
        ],
        "updated_at": "2017-03-07T09:51:56.582Z"
      }
=end

=begin
  @apiDefine RecipientSnap
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "id": "56f1cb33-d853-45e9-942a-ddb384cfd56a",
        "user_id": "1739f0be-971a-4874-b6a7-2de699abae04",
        "file": {
          "url": "/uploads/snap/file/56f1cb33-d853-45e9-942a-ddb384cfd56a/Zrzut_ekranu_2016-12-21_o_20.03.02.png"
        },
        "file_type": "photo",
        "duration": 10,
        "view_count": 0,
        "created_at": "2017-03-07T09:51:56.582Z",
        "updated_at": "2017-03-07T09:51:56.582Z"
      }
=end

=begin
  @apiDefine SnapList
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "collection": [
          {
            "id": "56f1cb33-d853-45e9-942a-ddb384cfd56a",
            "user_id": "1739f0be-971a-4874-b6a7-2de699abae04",
            "file": {
              "url": "/uploads/snap/file/56f1cb33-d853-45e9-942a-ddb384cfd56a/Zrzut_ekranu_2016-12-21_o_20.03.02.png"
            },
            "file_type": "photo",
            "duration": 10,
            "view_count": 0,
            "created_at": "2017-03-07T09:51:56.582Z",
            "updated_at": "2017-03-07T09:51:56.582Z"
          },
          {
            "id": "4125a087-097f-4c83-b9ee-03b580b133a5",
            "user_id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
            "file": {
              "url": "/uploads/snap/file/4125a087-097f-4c83-b9ee-03b580b133a5/Zrzut_ekranu_2017-01-03_o_09.08.13.png"
            },
            "file_type": "photo",
            "duration": 10,
            "created_at": "2017-03-07T09:56:17.587Z",
            "recipients": [
              {
                "id": "1739f0be-971a-4874-b6a7-2de699abae04",
                "name": "admin",
                "display_name": "admin",
                "email": "t@t.com",
                "role": "admin",
                "created_at": "2016-12-29T07:30:04.270Z",
                "updated_at": "2017-03-06T13:13:39.237Z"
              }
            ],
            "updated_at": "2017-03-07T09:56:17.587Z"
          }
        ]
      }
=end

=begin
  @apiDefine ChatMessage
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "id": "5881f20b-e0cf-445a-91e7-46e20d3a41d8",
        "message": "test message",
        "author_id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
        "recipient_id": "1739f0be-971a-4874-b6a7-2de699abae04",
        "readed_at": null,
        "created_at": "2017-03-07T12:32:04.367Z",
        "updated_at": "2017-03-07T12:32:04.367Z"
      }
=end

=begin
  @apiDefine ChatMessageList
  @apiSuccessExample {json} Success-Response:
    HTTP/1.1 200 OK
      {
        "collection": [
          {
            "id": "5881f20b-e0cf-445a-91e7-46e20d3a41d8",
            "message": "test message",
            "author_id": "dc7bb84e-94f0-4ebe-84a0-1d16c2bad206",
            "recipient_id": "1739f0be-971a-4874-b6a7-2de699abae04",
            "readed_at": null,
            "created_at": "2017-03-07T12:32:04.367Z",
            "updated_at": "2017-03-07T12:32:04.367Z"
          }
        ]
      }
=end