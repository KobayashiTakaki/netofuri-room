module ApplicationHelper
  def error_messages(errors)
    errors.messages.map { |k, v| v }.flatten!
  end
end
