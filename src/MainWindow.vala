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

public class MainWindow : Gtk.Window {
    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            border_width: 0,
            icon_name: Rundown.instance.application_id,
            resizable: true,
            title: "Rundown",
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        default_height = 800;
        default_width = 1280;

        var header = new Gtk.HeaderBar ();
        header.show_close_button = true;
        header.has_subtitle = false;

        // var paid_info_bar = new PaidInfoBar ();
        // var native_info_bar = new NativeInfoBar ();

        var grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;
        // grid.add (paid_info_bar);
        // grid.add (native_info_bar);
        grid.add (new Gtk.Label ("Hello world"));

        set_titlebar (header);
        add (grid);

        show_all ();
    }
}
