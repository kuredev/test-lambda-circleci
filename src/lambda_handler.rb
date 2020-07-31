require "json"

class LambdaHandler
  def self.lambda_handler(*)
    puts "hogehoge"

    { result: true }
  end
end
