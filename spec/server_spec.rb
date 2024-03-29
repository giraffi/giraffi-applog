require_relative 'spec_helper'

describe Server do
  before(:each) do
    @message = 'my_app_log'
    @time = Time.now().to_i
    @type = 'app'
    @level = 'debug'
    @limit = 1 # Max number of documents to retrieve
  end

  describe "GET '/applogs.json'" do
    context 'when all params are given and valid'  do
      it 'should be successful' do
        get '/applogs.json', {:message => @message, :level => @level, :limit => @limit}
        last_response.should be_ok
      end
    end
  end

  describe "GET '/applogs.json'" do
    context 'when no param is given'  do
      it 'should be successful' do
        get '/applogs.json'
        last_response.should be_ok
      end
    end
  end

  describe "POST '/applogs.json'" do
    context 'when all params are given and valid'  do
      it 'should be successful' do
        post '/applogs.json', { :applog => { :message => @message, :time => @time, :type => @type, :level => @level } }.to_json,
          "CONTENT_TYPE" => "application/json"

        last_response.status.should == 201
      end
    end
  end

  describe "POST '/applogs.json'" do
    context 'when no param is given'  do
      it 'should be validation error' do
        post '/applogs.json', { :applog => { } }.to_json,
          'CONTENT_TYPE' => 'application/json'
        last_response.status.should == 400
        last_response.body.should include("is not a number")
        last_response.body.should include("can't be blank")
      end
    end
  end

end
