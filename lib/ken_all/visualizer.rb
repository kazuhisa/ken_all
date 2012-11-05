# coding: utf-8

module KenAll
  class Visualizer
    RED = 1
    GREEN = 2

    def initialize(visualize = true)
      @visualize = visualize
    end

    def screen_init
      if @visualize
        Curses.init_screen
        Curses.start_color
        Curses.init_pair RED, Curses::COLOR_RED, Curses::COLOR_BLACK
        Curses.init_pair GREEN, Curses::COLOR_GREEN, Curses::COLOR_BLACK

        Curses.setpos(0, 1)
        Curses.attrset(Curses.color_pair(GREEN))
        Curses.addstr("******** KEN_ALL ********")

        Curses.setpos(1, 1)
        Curses.attrset(Curses.color_pair(GREEN))
        Curses.addstr("Welcome to amazing world.")

        Curses.setpos(2, 1)
        Curses.attrset(Curses.color_pair(RED))
        Curses.addstr("+download")
        Curses.setpos(3, 1)
        Curses.attrset(Curses.color_pair(RED))
        Curses.addstr("+unzip")
        Curses.setpos(4, 1)
        Curses.attrset(Curses.color_pair(RED))
        Curses.addstr("+import")

        Curses.setpos(5, 1)
        Curses.attrset(Curses.color_pair(GREEN))
        Curses.addstr("*************************")
        Curses.refresh
      end
      yield
    ensure
      Curses.close_screen if @visualize
    end

    def download_status
      yield
      return unless @visualize
      Curses.setpos(2, 1)
      Curses.attrset(Curses.color_pair(GREEN))
      Curses.addstr("+download")
      Curses.refresh
    end

    def unzip_status
      yield
      return unless @visualize
      Curses.setpos(3, 1)
      Curses.attrset(Curses.color_pair(GREEN))
      Curses.addstr("+unzip")
      Curses.refresh
    end

    def import_status
      yield
      return unless @visualize
      Curses.setpos(4, 1)
      Curses.attrset(Curses.color_pair(GREEN))
      Curses.addstr("+import")
      Curses.refresh
    end
  end
end