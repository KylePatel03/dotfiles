from libqtile import hook, layout, bar, widget, qtile
from libqtile.layout import MonadTall, Max, Columns
from libqtile.lazy import lazy
from libqtile.config import Key, Group, KeyChord, Match, Click, Drag, Screen
from libqtile.command import lazy
import os
from subprocess import check_output

#@hook.subscribe.startup_once
#def autostart():
#    home = os.path.expanduser('~/.config/qtile/autostart.sh')
#    subprocess.call([home])

# Global Settings

dgroups_key_binder = None
dgroups_app_rules = []
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"

wmname = "Qtile"
widget_defaults = dict(
    font="Font Awesome 5 Free",
    fontsize=12,
    padding=5,
)
extension_defaults = widget_defaults.copy()

# Keys

mod = "mod4"
terminal = "alacritty"
browser = "brave"
email = "thunderbird"
music = "rhytmbox"
password_manager = "bitwarden-desktop"
file_manager = "thunar"
notes = "obsidian"


keys = [

    # Window Navigation with Super
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod],"space",lazy.layout.next()),
    Key([mod], "Tab", lazy.next_layout()),
    # Given a list of all open applications, switch to the selected application's workspace
    Key([mod], "grave", lazy.spawn("rofi -show window")),

    # Resizing windows keychord (Monad Layouts)
    KeyChord([mod],"w", [
             Key([], "j", lazy.layout.shrink()),
             Key([], "k", lazy.layout.grow()),
             Key([], "0", lazy.layout.reset(),lazy.layout.normalize()),
         ],mode=True,name="Window"),
    
    # Scripts keychord
    KeyChord([mod],"x",[
            Key([],"b",lazy.spawn("dm-bluetooth")),
            Key([],"l",lazy.spawn("dm-powermenu")),
            Key([],"e",lazy.spawn("dm-emoji")),
        ],mode=False,name="Scripts",),

    Key([mod,"mod1"],"p", lazy.spawn(password_manager)),

    # Launch terminal
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Launch applications with Super+Alt
    Key([mod,"mod1"], "Return", lazy.spawn("rofi -show combi")),
    Key([mod,"mod1"],"b", lazy.spawn(browser)),
    Key([mod,"mod1"],"e", lazy.spawn(email)),
    Key([mod,"mod1"],"f",lazy.spawn(file_manager)),
    Key([mod,"mod1"],"p", lazy.spawn(password_manager)),
    Key([mod,"mod1"],"n",lazy.spawn(notes)),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift",], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key([mod, "shift", "control"], "h", lazy.layout.swap_column_left()),
    Key([mod, "shift", "control"], "l", lazy.layout.swap_column_right()),
    Key([mod, "shift"], "space", lazy.layout.flip()),

    # Super+Control
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "control"], "b", lazy.hide_show_bar(), desc="Toggle Status Bar"),

    # Function bindings
    Key([], "XF86AudioRaiseVolume",lazy.spawn("pamixer -i 5")),
    Key([], "XF86AudioLowerVolume",lazy.spawn("pamixer -d 5")),
    Key([], "XF86AudioMute",lazy.spawn("pamixer --toggle-mute")),

    # Screenshot bindings
    Key([],"Print",lazy.spawn("flameshot gui -p /home/kyle/Pictures/Screenshots/")),
    Key(["shift"],"Print",lazy.spawn("flameshot screen -n 0 -p /home/kyle/Pictures/Screenshots/")),
]

# Mouse Keys

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Groups
groups = [Group(i) for i in "1234567890"]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),
        Key([mod], "Right", lazy.screen.next_group(), desc="Switch to next group"),
        Key([mod], "Left", lazy.screen.prev_group(), desc="Switch to previous group"),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False), desc="Switch to & move focused window to group {}".format(i.name)),
    ])

# Layouts
layouts = [
    MonadTall(border_focus='#966FD6', border_normal='#000000',margin=7,border_width=3,single_border_width=0,single_margin=0),
    Max(),
]

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    ],
    border_focus = "#0000ff",
    border_normal = "#000000",
    border_width = 1,
    fullscreen_border_width = 0,
    max_border_width = 0,
    )


screens = [
    Screen(
        top=bar.Bar([
                widget.GroupBox(
                    highlight_method='line',
                    this_screen_border="#5294e2",
                    this_current_screen_border="#5294e2",
                    active="#ffffff",
                    inactive="#848e96",
                    background="#2f343f"),
                widget.Spacer(length=5),
                widget.CurrentLayoutIcon(
                    fmt="{}",
                    scale=0.6,
                    mouse_callbacks = {},
                ),
                widget.WindowCount(
                    fmt="{}",
                ),
                widget.Sep(
                    padding=5,
                    linewidth=0,
                ),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Sep(
                    padding=10,
                    linewidth=2,
                ),
                widget.WindowName(
                    foreground="#ffffff",
                    format="{name}",
                    fmt='{}',
                    padding=10,
                ),
                widget.GenPollText(
                    func = lambda: check_output(["sb-device","0"]).decode("utf-8").strip(),
                    fmt = "{}",
                    update_interval=None,
                    markup=False,
                    mouse_callbacks = {
                        # Left click to mount
                        "Button1": lambda: qtile.cmd_spawn(os.path.expanduser("sb-device 1")),
                        # Right click to unmount
                        "Button3": lambda: qtile.cmd_spawn(os.path.expanduser("sb-device 2")),
                    }
                ),
                widget.Sep(
                    padding=10,
                    linewidth=2,
                ),
                widget.GenPollText(
                        func = lambda: check_output("sb-packages").decode("utf-8").strip(),
                        fmt = "{}",
                        update_interval=None,
                        markup=False,
                ),
                widget.Sep(
                    padding=10,
                    linewidth=2,
                ),
                widget.GenPollText(
                    func = lambda: check_output("sb-volume").decode("utf-8").strip(),
                    fmt = "{}",
                    update_interval=None,
                    markup=False,
                    mouse_callbacks= {
                        # Left Click
                        'Button1': lambda: qtile.cmd_spawn(os.path.expanduser('pavucontrol')),
                        # Right Click
                        'Button3': lambda: qtile.cmd_spawn(os.path.expanduser('dm-bluetooth')),
                    },
                ),
                widget.Sep(
                        padding=10,
                        linewidth=2,
                ),
                widget.GenPollText(
                        func = lambda: check_output("sb-memory").decode("utf-8").strip(),
                        fmt = "{}",
                        update_interval = 10,
                        markup = False,
                ),
                widget.Sep(
                    padding=10,
                    linewidth=2,
                ),
                widget.Clock(
                        fmt = "📅 {}",
                        #format="%d/%m/%y %H:%M",
                        format="%A %d %B %Y %H:%M %p",
                        markup = False,
                        update_interval = 60,
                ),
                widget.Sep(
                    padding=10,
                    linewidth=2,
                ),
                widget.TextBox(
                    text='',
                    mouse_callbacks= {
                        'Button1':
                        lambda: qtile.cmd_spawn(os.path.expanduser('dm-powermenu'))
                    },
                    foreground="#ffffff",
                )
            ],
            30,  # height in px
            background="#404552"  # background color
        ), ),
]

colors = [
        ["#282c34", "#282c34"], # panel background
        ["#3d3f4b", "#434758"], # background for current screen tab
        ["#ffffff", "#ffffff"], # font color for group names
        ["#ff5555", "#ff5555"], # border line color for current tab
        ["#74438f", "#74438f"], # border line color for 'other tabs' and color for 'odd widgets'
        ["#4f76c7", "#4f76c7"], # color for the 'even widgets'
        ["#e1acff", "#e1acff"], # window name
        ["#ecbbfb", "#ecbbfb"]  # backbround for inactive screens
] 