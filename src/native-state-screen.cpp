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
#include "native-state-screen.h"

#include <cstring>
#include <csignal>
#include <assert.h>
#include <stdlib.h>

volatile bool NativeStateScreen::should_quit_ = false;

NativeStateScreen::NativeStateScreen() : display_(0), window_(0)
{
}

NativeStateScreen::~NativeStateScreen()
{
}

static void
getQNXDisplay(screen_display_t* display, int idx, screen_context_t screen_ctx)
{
    screen_display_t* screen_dpy;
    int               displayId;
    int               rc;
    int               ndisplays;

    assert(display != NULL);

    rc = screen_get_context_property_iv(screen_ctx, SCREEN_PROPERTY_DISPLAY_COUNT, &ndisplays);
    assert(rc == 0);

    screen_dpy = (screen_display_t*)calloc(ndisplays, sizeof(screen_display_t));
    assert(screen_dpy != NULL);

    rc = screen_get_context_property_pv(screen_ctx, SCREEN_PROPERTY_DISPLAYS, (void **)screen_dpy);
    assert(rc == 0);

    if(idx >= ndisplays) {
	idx = ndisplays-1;
    }

    /* check if screen_dpy[idx] is valid */
    rc = screen_get_display_property_iv(screen_dpy[idx], SCREEN_PROPERTY_ID, &displayId);
    assert(rc == 0);

    *display = screen_dpy[idx];

    free(screen_dpy);

    return;
}

bool
NativeStateScreen::init_display()
{
    struct sigaction sa;
    sa.sa_handler = &NativeStateScreen::quit_handler;
    sa.sa_flags = 0;
    sigemptyset(&sa.sa_mask);

    sigaction(SIGINT,  &sa, NULL);
    sigaction(SIGTERM, &sa, NULL);

    display_ = new struct my_display;

    if (!display_) {
	return false;
    }

    screen_create_context(&display_->context, SCREEN_APPLICATION_CONTEXT);
    if (!display_->context) {
	return false;
    }

    display_->egl_display = EGL_DEFAULT_DISPLAY;

    getQNXDisplay(&display_->screen_display, (int)(unsigned long)display_->egl_display, display_->context);
    if (!display_->screen_display) {
	return false;
    }

    return true;
}

void*
NativeStateScreen::display()
{
    return static_cast<void *>(display_->egl_display);
}

bool
NativeStateScreen::create_window(WindowProperties const& properties)
{
    int       windowSize[2] = {0,0};
    const int nbuffers      = 2;
    int       format = SCREEN_FORMAT_RGBA8888;
    int       usage  = SCREEN_USAGE_OPENGL_ES2 | SCREEN_USAGE_READ |
                       SCREEN_USAGE_WRITE | SCREEN_USAGE_NATIVE;

    window_ = new struct my_window;
    window_->properties = properties;

    screen_create_window(&window_->window, display_->context); 
    screen_set_window_property_pv(window_->window, SCREEN_PROPERTY_DISPLAY, (void **)(&display_->screen_display));

    screen_set_window_property_iv(window_->window, SCREEN_PROPERTY_FORMAT, &format);
    screen_set_window_property_iv(window_->window, SCREEN_PROPERTY_USAGE, &usage);

    if (window_->properties.fullscreen) {
	screen_get_display_property_iv(display_->screen_display, SCREEN_PROPERTY_SIZE, windowSize);
	window_->properties.width  = windowSize[0];
	window_->properties.height = windowSize[1];
    } else {
	windowSize[0] = window_->properties.width;
	windowSize[1] = window_->properties.height;
    }

    screen_set_window_property_iv(window_->window, SCREEN_PROPERTY_SIZE, windowSize);
    screen_set_window_property_cv(window_->window, SCREEN_PROPERTY_ID_STRING, 8, "glmark2");
    screen_create_window_buffers(window_->window, nbuffers);

    return true;
}

void*
NativeStateScreen::window(WindowProperties &properties)
{
    if (window_) {
	properties = window_->properties;
	return window_->window;
    }

    return 0;
}

void
NativeStateScreen::visible(bool /*v*/)
{
}

bool
NativeStateScreen::should_quit()
{
    return should_quit_;
}

void
NativeStateScreen::flip()
{
}

void
NativeStateScreen::quit_handler(int /*signum*/)
{
    should_quit_ = true;
}

