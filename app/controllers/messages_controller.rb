class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /messages or /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1 or /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages or /messages.json

  def create
    @message = Message.new(message_params)

    # In your app, e.g. an initializer or controller
    cable_connection = ActiveRecord::Base.connected_to(role: :writing, shard: :cable) do
      ActiveRecord::Base.connection
    end
    
    Rails.logger.debug "DEBUG - Cable DB config: #{cable_connection.pool.db_config.name}"
    Rails.logger.debug "DEBUG - Cable DB config URL: #{cable_connection.pool.db_config.database}"
    Rails.logger.debug "DEBUG - Cable connection config: #{cable_connection.pool.spec.config.inspect}"
    begin
      @message.save!

      html = ApplicationController.render(
        partial: "messages/message",
        locals: { message: @message }
      )

      total = Message.count
      Rails.logger.debug "DEBUG total messages: #{total}"

      if total > 200
        Rails.logger.debug "DEBUG clean up messages"
        Message.order(id: :asc).limit(total - 200).destroy_all
      end

      ActionCable.server.broadcast("PhoneConnectChannel", { content: html })
      # redirect_to messages_path, notice: "Message sent"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Message save failed: #{e.message}"
      render :index, alert: "Message failed"
    end
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to messages_path, status: :see_other, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:content)
    end
end
