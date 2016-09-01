#!/Applications/Shoes.app/Contents/MacOS/shoes

Shoes.setup do
  gem 'rotp'
end

require 'rotp'

Shoes.app title: 'One-Time Passwords', width: 230, height: 250, resizable: false do
  # Key – provider, valud – token seed
  @tokens = {
    'Example': 'DEADBEEF'
  }

  background white
  background tan, height: 44

  @caption = caption '', margin: 12, stroke: white, align: 'center'

  stack do
    flow do
      @paragraphs = []
      @tokens.size.times do |i|
        @paragraphs << stack(margin: 8) do; end
      end
    end
  end

  every(1) do
    time = Time.now

    minute = time.min
    if time.sec > 30
      minute += 1
      second = 0
    else
      second = 30
    end

    hour = time.hour
    if minute > 59 && second = 30
      hour += 1
    end

    new_time = Time.new(time.year, time.month, time.day, hour, minute, second)

    @caption.replace "Valid yet: #{(time - new_time).to_i.abs} sec."

    idx = 0
    @tokens.each do |provider, token_seed|
      @paragraphs[idx].clear do
        para("#{provider} = #{ROTP::TOTP.new(token_seed).now}")
      end

      idx += 1
    end
  end
end

