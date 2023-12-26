require "telegram/bot"

module SendImage
  extend ActiveSupport::Concern

  included do
    before_create :send_image_to_telegram
  end

  private

  def send_image_to_telegram
    if image.present?
      token = ENV["TELEGRAM_TOKEN"]
      bot = Telegram::Bot::Client.new(token)
      input_file = Faraday::UploadIO.new(image.tempfile, image.content_type)
      bot.api.send_photo(
        chat_id: ENV["TELEGRAM_CHAT_ID"],
        photo: input_file
      )
      self.with_image = true
    end
  end
end
