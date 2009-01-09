/*=====================================================================*
 *                   Copyright (C) 2003 Paul Mineiro                   *
 *                                                                     *
 * This program is free software; you can redistribute it and/or       *
 * modify it under the terms of the GNU General Public License         *
 * as published by the Free Software Foundation; either version 2      *
 * of the License, or (at your option) any later version.              *
 *                                                                     *
 * This program is distributed in the hope that it will be useful,     *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of      *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU   *
 * General Public License for more details.                            *
 *                                                                     *
 * You should have received a copy of the GNU General Public License   *
 * along with this program; if not, write to the Free Software         *
 * Foundation, Inc., 59 Temple Place, Suite 330,                       *
 * Boston, MA 02111-1307  USA                                          *
 *                                                                     *
 * Contact: Paul Mineiro <paul@mineiro.com>                            *
 *=====================================================================*/

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main (int    argc,
          char **argv)
{
  struct stat buf;

  if (argc < 2)
    {
      fprintf (stderr, "ww-test-x: missing argument\n");

      exit (2);
    }

  if (stat (argv[1], &buf) < 0)
    {
      fprintf (stderr,
               "ww-test-x: cannot stat %s: %s\n",
               argv[1],
               strerror (errno));

      exit (2);
    }

  if (buf.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH))
    {
      exit (0);
    }
  else
    {
      exit (1);
    }
}
