module Mrbmacs
  class Application
    def replace_string(str = nil, newstr = nil, query = false)
      if str == nil or newstr == nil
        @frame.echo_win.sci_clear_all
        str = @frame.echo_gets("Replace string: ", "")
        if str != nil
          newstr = @frame.echo_gets("Replace string #{str} with: ", "")
        end
      end
      @frame.view_win.sci_begin_undo_action
      @frame.view_win.sci_set_target_start(@frame.view_win.sci_get_current_pos)
      @frame.view_win.sci_set_target_end(@frame.view_win.sci_get_length)
      while (pos = @frame.view_win.sci_search_in_target(str.length, str)) != -1
        if query == true
          @frame.view_win.sci_set_sel(@frame.view_win.sci_get_target_start, @frame.view_win.sci_get_target_end)
          @frame.view_win.refresh
          case @frame.y_or_n("Query replacing #{str} with #{newstr}:")
          when true
            @frame.view_win.sci_replace_target(newstr.length, newstr)
          when false # cancel
            @frame.echo_puts("Quit")
            break
          end
          @frame.view_win.refresh
        else
          @frame.view_win.sci_replace_target(newstr.length, newstr)
        end
        @frame.view_win.sci_set_target_start(@frame.view_win.sci_get_target_end)
        @frame.view_win.sci_set_target_end(@frame.view_win.sci_get_length)
      end
      @frame.view_win.sci_end_undo_action
    end

    def query_replace(str = nil, newstr = nil)
      replace_string(nil, nil, true)
    end
  end
end