require 'friendly_log_handler'
class TwoAdiumOneCup < Shoes; end

Shoes.app(:width => 277, :height => 200) do
  background "#3FA1BF".."#0F3155"

  stack(:top => 60) {
    banner "two adium, one cup", 
      :align => "center",
      :font => "Helvetica",
      :size => 16,
      :stroke => white
  }
    
  @remote = button "Grab logs from"
  @remote_path = ''
  @local = button "Copy logs to"
  @local_path = ''
  
  flow {
    @remote.click {
      @remote_path = ask_open_folder
    }
  
    @local.click {
      @local_path = ask_open_folder
    }
  }
  
  flow {
    button("Import").click {
      if @remote_path == ''
        alert "You must select a place to import logs from"
      elsif @local_path == ''
        alert "You must select a place to copy logs to"
      else
        FriendlyLogHandler.new(@remote_path, @local_path, false).import
        alert "Conversations imported."
      end
    }
  }
end