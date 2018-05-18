require_relative "spec_helper"

describe "session handling" do
  include CookieJar

  it "should give a warning if session variable is not available" do
    app do |r|
      begin
        session
      rescue Exception => e
        e.message
      end
    end

    body.must_match(/use Rack::Session::Cookie/)
  end

  it "should return session if available" do
    app(:bare) do
      use Rack::Session::Cookie, :secret=>'1'

      route do |r|
        r.on do
          (session[1] ||= 'a'.dup) << 'b'
          session[1]
        end
      end
    end

    _, h, b = req
    b.join.must_equal 'ab'
    _, h, b = req
    b.join.must_equal 'abb'
    _, h, b = req
    b.join.must_equal 'abbb'
  end
end
