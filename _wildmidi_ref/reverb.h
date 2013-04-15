/*
	reverb.h

 	Midi Wavetable Processing library

    Copyright (C) Chris Ison 2001-2011

    This file is part of WildMIDI.

    WildMIDI is free software: you can redistribute and/or modify the player
    under the terms of the GNU General Public License and you can redistribute
    and/or modify the library under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation, either version 3 of
    the licenses, or(at your option) any later version.

    WildMIDI is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License and
    the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU General Public License and the
    GNU Lesser General Public License along with WildMIDI.  If not,  see
    <http://www.gnu.org/licenses/>.

    Email: wildcode@users.sourceforge.net
*/

#ifndef __REVERB_H
#define __REVERB_H

struct _rvb {
	/* filter data */
	signed long int l_buf_flt_in[8][6][2];
	signed long int l_buf_flt_out[8][6][2];
	signed long int r_buf_flt_in[8][6][2];
	signed long int r_buf_flt_out[8][6][2];
	signed long int coeff[8][6][5];
	/* buffer data */
	signed long int *l_buf;
	signed long int *r_buf;
	int l_buf_size;
	int r_buf_size;
	int l_out;
	int r_out;
	int l_sp_in[8];
	int r_sp_in[8];
	int l_in[4];
	int r_in[4];
	int gain;
    unsigned long int max_reverb_time;
};

extern void reset_reverb (struct _rvb *rvb);
extern struct _rvb *init_reverb(int rate, float room_x, float room_y, float listen_x, float listen_y);
extern void free_reverb (struct _rvb *rvb);
extern void do_reverb (struct _rvb *rvb, signed long int *buffer, int size);

#endif // __REVERB_H
