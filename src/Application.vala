/*
* Copyright © 2019 Cassidy James Blaede (https://cassidyjames.com)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Cassidy James Blaede <c@ssidyjam.es>
*/

public class Rundown : Gtk.Application {
    public static GLib.Settings settings;

    public Rundown () {
        Object (
            application_id: "com.github.cassidyjames.rundown",
            flags: ApplicationFlags.HANDLES_OPEN
        );
    }

    public static Rundown _instance = null;
    public static Rundown instance {
        get {
            if (_instance == null) {
                _instance = new Rundown ();
            }
            return _instance;
        }
    }

    static construct {
        settings = new Settings (Rundown.instance.application_id);
    }

    protected override void activate () {
        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Ctrl>Q"});

        quit_action.activate.connect (() => {
            quit ();
        });

        Utils.Inhibitor.initialize (this);

        var app_window = new MainWindow (this);
        app_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Rundown ();
        return app.run (args);
    }
}

