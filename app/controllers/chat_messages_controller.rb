class ChatMessagesController < ApplicationController
  before_action :authenticate_user
  load_and_authorize_resource class: 'ChatMessage', except: :create

=begin
  @api {get} /chat_messages/thread/:participant Get message thread
  @apiName getChatMessagesThread
  @apiGroup chat message
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiParam {uuid} participant Id of user from this thread
  @apiUse ChatMessageList
  @apiUse ErrorUnauthorized
=end
  def thread
    @chat_messages = ChatMessage.unread_thread current_user, params[:participant]

    setup_pagination(page: params[:page], page_size: params[:page_size])
    setup_sorting(sort_by: params[:sort_by], sort_order: params[:sort_order], model: ChatMessage)
    collection = @chat_messages.page(@page).per(@per_page)
    collection = collection.order(@sort_by => @sort_order)
    collection = search_collection(collection, search_field: params[:search_field], search_value: params[:search_value])
    render json: collection,
           serializer: CollectionSerializer,
           each_serializer: ChatMessageSerializer,
           root: COLLECTION_LABEL,
           adapter: :json,
           count: collection.size,
           page: page,
           page_size: page_size
  end

=begin
  @api {post} /chat_messages Send message
  @apiName postChatMessages
  @apiGroup chat message
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiUse ChatMessageCreateParams
  @apiUse ChatMessage
  @apiUse ErrorUnauthorized
  @apiUse ErrorBadParams
=end
  def create
    @chat_message = ChatMessage.new create_params
    @chat_message.author_id = current_user.id
    if @chat_message.save
      render json: @chat_message,
             serializer: ChatMessageSerializer,
             status: :created
      ChatMessageReceivedJob.perform_now @chat_message
    else
      render json: @chat_messages.errors,
             status: :bad_request
    end
  end

=begin
  @api {put} /chat_messages/:id/read Mark message as a read
  @apiDescription This method is available only for message recipient
  @apiName putChatMessagesId
  @apiGroup chat message
  @apiPermission user
  @apiUse AuthorizationHeaders
  @apiParam {uuid} id Message id
  @apiUse SuccessNoContent
  @apiUse ErrorBadRequest
  @apiUse ErrorUnauthorized
=end
  def read
    @chat_messages = ChatMessage.thread(@chat_message.author_id, @chat_message.recipient_id)
    @chat_messages.where("created_at <= '#{@chat_message.created_at}' AND readed_at = NULL")

    if @chat_messages.update(read_at: DateTime.now)
      render status: :no_content
      ChatMessageReadJob.perform_now @chat_message
    else
      render status: :bad_request
    end
  end

=begin
  @apiDefine ChatMessageCreateParams
  @apiParam {uuid} recipient_id Recipient id
  @apiParam {string} message Message
=end
  private
  def create_params
    params.permit(:recipient_id, :message)
  end
end
