module Scimre
  class << self
    def eval_last_exp(app)
      text, pos = app.frame.view_win.get_curline
      begin
        ret = instance_eval(text[0..pos-1])
      rescue
#        $stderr.puts $!
      end
      app.frame.view_win.newline
      app.frame.view_win.addtext(ret.to_s.length, ret.to_s)
      app.frame.view_win.newline
    end
  end
end
