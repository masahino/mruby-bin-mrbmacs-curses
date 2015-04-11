module Scimre
  class KeyMap
    include Scintilla
    attr_accessor :command_list
    def initialize(win)
      @command_list = {}
      keymap = {
        'C-a' => SCI_VCHOME,
        'C-b' => SCI_CHARLEFT,
        'C-d' => SCI_CLEAR,
        'C-e' => SCI_LINEEND,
        'C-f' => SCI_CHARRIGHT,
        'C-h' => SCI_DELETEBACK,
        'C-k' => "kill-line",
        'C-w' => "cut-region",
        'C-y' => SCI_PASTE,
        'C-@' => "set-mark", # C-SPC
        'C-x u' => SCI_UNDO,
        'M-w' => "copy-region",
        'M-<' => "beginning-of-buffer",
        'M->' => "end-of-buffer",
      }
      set_keymap(win, keymap)
    end
    
    def set_keymap(win, keymap)
      keymap.each do |k, v|
        strokes = k.split(" ").size
        #      case v.class.to_s
        if strokes == 1 and v.class.to_s == "Fixnum" 
          set_keybind(win, k, v)
        else
          #      when "String"
          @command_list[k] = v
          #      else
          #        $stderr.puts v.class
        end
      end
    end

    def set_keybind(win, key, cmd)
      keydef = 0
      if key =~ /^(\w)-(\w)$/
        if $1 == "C"
          keydef += Scintilla::SCMOD_CTRL << 16
        end
        keydef += $2.ord
      end
      win.assign_cmdkey(keydef, cmd)
    end
  end

  class ViewKeyMap < KeyMap
    def initialize(win)
      super.initialize(win)
      keymap = {
        'Enter' => "newline",
        'Tab' => "indent",
#        'C-j' => "eval-last_exp",
        'C-m' => SCI_NEWLINE,
        'C-n' => SCI_LINEDOWN,
        'C-p' => SCI_LINEUP,
        'C-s' => "isearch-forward",
        'C-v' => SCI_PAGEDOWN,
        'C-x' => "prefix",
        'C-y' => SCI_PASTE,
        'C-x b' => "switch-to-buffer",
        'C-x k' => "kill-buffer",
        'C-x C-c' => "save_buffers_kill-terminal",
        'C-x C-f' => "find-file",
        'C-x C-s' => "save-buffer",
        'M-x' => "extend",
      }
      set_keymap(win, keymap)
    end
  end
  
  class EchoWinKeyMap < KeyMap
    def initialize(win)
      super.initialize(win)
      keymap = {
        'Tab' => "completion",
      }
      set_keymap(win, keymap)
    end
  end
end
