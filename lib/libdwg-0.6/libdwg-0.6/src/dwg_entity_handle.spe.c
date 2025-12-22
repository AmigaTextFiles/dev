/*****************************************************************************/
/*  LibDWG - free implementation of the DWG file format                      */
/*                                                                           */
/*  Copyright (C) 2013 Free Software Foundation, Inc.                        */
/*                                                                           */
/*  This library is free software, licensed under the terms of the GNU       */
/*  General Public License as published by the Free Software Foundation,     */
/*  either version 3 of the License, or (at your option) any later version.  */
/*  You should have received a copy of the GNU General Public License        */
/*  along with this program.  If not, see <http://www.gnu.org/licenses/>.    */
/*                                                                           */
/*****************************************************************************/

  if (FIELD_VALUE(entity_mode) == 0)
    {
      FIELD_HANDLE(subentity, 3);
    }

  ENT_REACTORS(4)
  ENT_XDICOBJHANDLE(3)

  VERSIONS(R_13, R_14)
    {
      FIELD_HANDLE(layer, 5);
      if (!FIELD_VALUE(isbylayerlt))
        {
          FIELD_HANDLE(ltype, 5);
        }
    }

  UNTIL(R_2000)
    {
      if (!FIELD_VALUE(nolinks))
        { // TODO: in R13, R14 these are optional. Look at page 53 in the spec for condition.
              FIELD_HANDLE(prev_entity, 4);
              FIELD_HANDLE(next_entity, 4);
            }
        }

  SINCE(R_2000)
    {
      FIELD_HANDLE(layer, 5);
      if (FIELD_VALUE(linetype_flags) == 3)
        {
          FIELD_HANDLE(ltype, 5);
        }
    }

  SINCE(R_2007)
    {
      if (FIELD_VALUE(material_flags)==3)
        {
          FIELD_HANDLE(material, ANYCODE);
        }
    }

  SINCE(R_2000)
    {
      if (FIELD_VALUE(plotstyle_flags)==3)
        {
          FIELD_HANDLE(plotstyle, 5);
        }
    }

