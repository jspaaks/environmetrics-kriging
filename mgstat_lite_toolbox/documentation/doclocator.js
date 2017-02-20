//
//Author : Jurriaan H. Spaaks
//Date   : October 2006
//
// This script takes care of the relational 
// hyperlinking, e.g. go two dirs up and 
// then to ...(the value of app_str).

function write_link(s,n_up,app_str)
      {
      var str01 = chop_first(s);
      var str02 = n_dir_up(str01,n_up);
      var link_str = str02 + app_str;
      return link_str;
      }


function chop_first(s)
      {
       var a = s.lastIndexOf(":/");
       var b = s.lastIndexOf("/");
       s = s.substring(a-1,b);
       return s;      
      }

function n_dir_up(s,n_up)
       {
       var i_last = s.lastIndexOf("/");
       var i=1;
       for (i=1;i<=n_up;i++)
          {
          i_last = s.lastIndexOf("/");
          s = s.substring(0,i_last);
          }
       return s;
       }
