/* 
Copyright (c) 2011 by Simon Schneegans

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <http://www.gnu.org/licenses/>. 
*/

namespace GnomePie {
	
    public class Deamon : GLib.Object {
    
        public static int main(string[] args) {
            Gtk.init (ref args);

            var deamon = new GnomePie.Deamon();
            deamon.run();
        }
        
        // TODO: may be not neccesary to be private member?
        private Indicator indicator {private get; private set;}       

        public Deamon() {        
            indicator = new Indicator();
            
            Settings.global.notify["show-indicator"].connect((s, p) => {
                indicator.active = Settings.global.show_indicator;
            });
            
            indicator.active = Settings.global.show_indicator;
            
            PieParser.parse();

            Posix.signal(Posix.SIGINT, sig_handler);
			Posix.signal(Posix.SIGTERM, sig_handler);
			
			stdout.printf("\nStarted happily...\n");
        }
        
        public void run() {
            Gtk.main();
        }
        
        private static void sig_handler(int sig) {
			stdout.printf("\nCaught signal (%d), bye!\n", sig);
			Gtk.main_quit();
		}

    }

}
