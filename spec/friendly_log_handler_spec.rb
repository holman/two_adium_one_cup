require File.join(File.dirname(__FILE__), %w[spec_helper])

describe FriendlyLogHandler do
  
  def init_friendly_log_handler
    @friendly_log_handler = FriendlyLogHandler.new('/tmp/adium_remote', '/tmp/adium_local', false)
    File.makedirs(@friendly_log_handler.remote)
    File.makedirs(@friendly_log_handler.local)
  end
  
  describe "when first created" do
    before(:each) do
      init_friendly_log_handler
    end

    it "should set values" do
      @friendly_log_handler.remote.should eql('/tmp/adium_remote')
      @friendly_log_handler.local.should eql('/tmp/adium_local')
      @friendly_log_handler.cleanup?.should be_false
    end
    
    it "should allow you to re-set cleanup" do
      @friendly_log_handler.cleanup = false
      @friendly_log_handler.cleanup?.should be_false
    end

    it "should ignore certain files" do
      %w{. .. .DS_Store}.each do |exclude|
        @friendly_log_handler.ignore_file?(exclude).should be_true
      end
    end

    it "should allow other files" do
      %w{this app needs a unicorn chaser}.each do |exclude|
        @friendly_log_handler.ignore_file?(exclude).should be_false
      end
    end  
  end
  
  describe "importing logs" do
    
    def create_logs
      File.makedirs(@friendly_log_handler.remote + "/holman")
      FileUtils.touch "#{@friendly_log_handler.remote}/holman/sample_conversation"
      
      File.makedirs(@friendly_log_handler.remote + "/jobs")
      FileUtils.touch "#{@friendly_log_handler.remote}/jobs/newer_sample_conversation"
      
      File.makedirs(@friendly_log_handler.local + "/jobs")
      FileUtils.touch "#{@friendly_log_handler.local}/jobs/older_sample_conversation"
    end
    
    def destroy_logs
      FileUtils.rm_rf(@friendly_log_handler.remote)
      FileUtils.rm_rf(@friendly_log_handler.local)
    end
    
    before(:each) do
      init_friendly_log_handler
      create_logs
      @friendly_log_handler.import
    end
    
    after(:each) do
      destroy_logs
    end
    
    it "should make local folders if we haven't talked to them before" do
      File.exist?(@friendly_log_handler.local + "/holman").should be_true
    end
    
    it "should move a new conversation to our local copy" do
      File.exist?(@friendly_log_handler.local + "/jobs/newer_sample_conversation").should be_true
    end
    
    it "should not delete the original remote directory unless told to do so" do
      File.exist?(@friendly_log_handler.remote + "/holman").should be_true
    end
    
    it "should delete the original remote directory if told to" do
      @friendly_log_handler.cleanup = true
      @friendly_log_handler.import
      File.exist?(@friendly_log_handler.remote + "/holman").should be_false
    end
  end
end