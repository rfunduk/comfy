class RCW

  def self.method_missing( method, *args )
    if args.is_a? Array
      case method.to_sym
      when :put
        args << nil if args.length == 1
      end
    elsif args.is_a? String
      args = [args]
    end

    begin
      #puts 'sending restclient : ' + method.to_s + " : " + args.join(',')
      RestClient.send( method, *args )
    rescue RestClient::Exception => e
      { :error => e.class,
        :message => e.message,
        :backtrace => '' }.to_json
    end
  end

end
