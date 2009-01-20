class TwoAdiumOneCup < Shoes; end

Shoes.app(:width => 277, :height => 150) do
  background "#3FA1BF".."#0F3155"

  stack(:top => 60) {
    banner "two adium, one cup", 
      :align => "center",
      :font => "Helvetica",
      :size => 16,
      :stroke => white
  }
    
  @remote = button "Grab logs from"
  @local = button "Copy logs to"

  flow {
    @remote.click {
      folder = ask_open_folder
      #Dir[folder].entries
      alert folder
    }
  
    @local.click {
      folder = ask_open_folder
      #Dir[folder].entries
      alert folder
    }
  }
end