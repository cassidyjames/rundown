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
    private static Gtk.Stack stack { get; set; }
    private static Gtk.Label timer_label { get; set; }

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            border_width: 12,
            height_request: 200,
            icon_name: Rundown.instance.application_id,
            resizable: false,
            title: "Rundown",
            width_request: 360,
            window_position: Gtk.WindowPosition.CENTER
        );
    }

    construct {
        stick ();
        set_keep_above (true);

        var context = get_style_context ();
        context.add_class ("rounded");
        context.add_class ("flat");

        var header = new Gtk.HeaderBar ();
        header.has_subtitle = false;
        header.show_close_button = true;
        header.get_style_context ().add_class ("default-decoration");
        header.get_style_context ().add_class ("flat");

        timer_label = new Gtk.Label (null);
        timer_label.margin = 24;
        timer_label.get_style_context ().add_class (Granite.STYLE_CLASS_H1_LABEL);

        var results_label = new Gtk.Label (null);
        results_label.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);

        var new_button = new Gtk.Button.with_label ("New Test");
        new_button.expand = true;
        new_button.valign = Gtk.Align.END;
        new_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);

        var results_grid = new Gtk.Grid ();
        results_grid.orientation = Gtk.Orientation.VERTICAL;
        results_grid.row_spacing = 6;

        results_grid.add (results_label);
        results_grid.add (new_button);

        stack = new Gtk.Stack ();
        stack.add_named (results_grid, "results");
        stack.add_named (timer_label, "timer");

        var grid = new Gtk.Grid ();
        grid.orientation = Gtk.Orientation.VERTICAL;
        grid.add (stack);

        set_titlebar (header);
        add (grid);

        show_all ();

        int64 test_start = Rundown.settings.get_int64 ("test-start");
        int64 test_end = Rundown.settings.get_int64 ("test-end");

        // if (test_start > int64.MIN && test_end > int64.MIN) {
            int test_length = (int) (test_end - test_start);
            results_label.label = _("Last test: %s").printf (Granite.DateTime.seconds_to_time (test_length));

            stack.visible_child = results_grid;
        // } else {
        //     new_test ();
        // }

        new_button.clicked.connect (() => {
            new_test ();
        });
    }

    private void new_test () {
        Utils.Inhibitor.get_instance ().inhibit ("Rundown battery life test");
        deletable = false;

        stack.visible_child_name = "timer";

        Rundown.settings.set_int64 ("test-start", int64.MIN);
        Rundown.settings.set_int64 ("test-end", int64.MIN);

        int64 test_start = new DateTime.now_utc ().to_unix ();
        Rundown.settings.set_int64 ("test-start", test_start);

        Timeout.add (1000, () => {
            int64 now = new DateTime.now_utc ().to_unix ();

            Rundown.settings.set_int64 ("test-end", now);

            int test_length = (int) (now - test_start);
            timer_label.label = Granite.DateTime.seconds_to_time (test_length);

            return true;
        });
    }
}
