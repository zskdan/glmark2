/*
 * Copyright © 2016 Zakaria ElQotbi
 *
 * This file is part of the glmark2 OpenGL (ES) 2.0 benchmark.
 *
 * glmark2 is free software: you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * glmark2 is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * glmark2.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *  Zakaria ElQotbi <zakaria.elqotbi@harman.com>
 */

#ifndef GLMARK2_NATIVE_STATE_SCREEN_H_
#define GLMARK2_NATIVE_STATE_SCREEN_H_

#include <vector>
#include <screen/screen.h>
#include <EGL/egl.h>

#include "native-state.h"

class NativeStateScreen : public NativeState
{
public:
    NativeStateScreen();
    ~NativeStateScreen();

    bool  init_display();
    void* display();
    bool  create_window(WindowProperties const& properties);
    void* window(WindowProperties& properties);
    void  visible(bool v);
    bool  should_quit();
    void  flip();

private:
    static void quit_handler(int signum);

    struct my_display {
	screen_context_t context;
	screen_display_t screen_display;
	EGLDisplay 	 egl_display;
    } *display_;

    struct my_window {
        WindowProperties properties;
	screen_window_t  window;
    } *window_;

    static volatile bool should_quit_;
};

#endif /* GLMARK2_NATIVE_STATE_WAYLAND_H_ */
