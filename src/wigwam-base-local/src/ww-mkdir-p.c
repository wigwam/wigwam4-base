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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static void 
ww_mkdir_p      (char *path)
{
  char *last_slash;
  struct stat buf;

  if (   stat (path, &buf) == 0
      && S_ISDIR (buf.st_mode))
    {
      return;
    }

  last_slash = strrchr (path, '/');

  if (last_slash != NULL)
    {
      char tmp;
      
      tmp = *last_slash;
      *last_slash = '\0';

      ww_mkdir_p (path);

      *last_slash = tmp;
    }

  /* check again in case of double slashes */

  if (   stat (path, &buf) == 0
      && S_ISDIR (buf.st_mode))
    {
      return;
    }

  if (mkdir (path, 0777) < 0)
    {
      fprintf (stderr, 
               "ww-mkdir-p: can't create '%s': %s\n",
               path,
               strerror (errno));

      exit (1);
    }
}

int main (int    argc,
          char **argv)
{
  if (argc < 2)
    {
      fprintf (stderr, "ww-mkdir-p: missing argument\n");

      exit (2);

    }

  ww_mkdir_p (argv[1]);

  exit (0);
}

