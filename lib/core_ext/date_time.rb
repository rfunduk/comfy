class Date
  def to_json
    %("#{strftime("%Y/%m/%d")}")
  end
  
  def self.from_json( string )
    return nil if string.nil?
    Date.parse( string )
  end
end

class Time
  def to_json
    %("#{strftime("%Y/%m/%d %H:%M:%S +0000")}")
  end
  
  def self.from_json( string )
    return nil if string.nil?
    d = DateTime.parse( string ).new_offset
    self.utc( d.year, d.month, d.day,
              d.hour, d.min, d.sec )
  end
end

