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
    // Once a month
    public const int64 NOTICE_SECS = 60 * 60 * 24 * 30;
    public const string DONATE_URL = "https://cassidyjames.com/pay";

    public static GLib.Settings settings;

    public bool warn_native_for_session = true;
    public bool warn_paid_for_session = true;

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

        var gtk_settings = Gtk.Settings.get_default ();
        gtk_settings.gtk_application_prefer_dark_theme = true;

        if (native ()) {
            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/cassidyjames/rundown/Application.css");
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );
        }

        var app_window = new MainWindow (this);
        app_window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Rundown ();
        return app.run (args);
    }

    public bool native () {
        string os = "";
        var file = File.new_for_path ("/etc/os-release");
        try {
            var map = new Gee.HashMap<string, string> ();
            var stream = new DataInputStream (file.read ());
            string line;
            // Read lines until end of file (null) is reached
            while ((line = stream.read_line (null)) != null) {
                var component = line.split ("=", 2);
                if (component.length == 2) {
                    map[component[0]] = component[1].replace ("\"", "");
                }
            }

            os = map["ID"];
        } catch (GLib.Error e) {
            critical ("Couldn't read /etc/os-release: %s", e.message);
        }

        string session = Environment.get_variable ("DESKTOP_SESSION");
        string stylesheet = Gtk.Settings.get_default ().gtk_theme_name;

        return (
            os == "elementary" &&
            session == "pantheon" &&
            stylesheet == "elementary"
        );
    }
}

