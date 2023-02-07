class ErrorMerchant
  attr_reader :message, :status, :code

  def initialize(message, status, code)
    @message = message
    @status = status
    @code = code
  end
end