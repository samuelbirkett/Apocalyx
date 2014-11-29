wb_usr = {
   contact : "iup@tecgraf.puc-rio.br",
   copyright_link : "http://www.tecgraf.puc-rio.br",
   copyright_name : "Tecgraf/PUC-Rio",
   title_bgcolor : "#3366CC",
   langs : ["en"],
   start_size : "220",
   file_title : "iup",
   use_items  : "yes",
   use_folders : "no",
   start_open : "1"
};

wb_usr.messages = {
  en : {
     revision_date : "31 Mar 2006",
     title : "IUP - Portable User Interface",
     bar_title : "IUP - Version 2.5"
  }
};

wb_usr.tree = 
{
  name: {nl: "IUP"},
  link: "home.html",
  folder:
  [
    {
      name: {pt: "Produto", en: "Product"},
      link: "prod.html",
      folder:
      [
        {
          name: {pt: "Visão Geral", en: "Overview"},
          link: "prod.html#visao_geral"
        },
        {
          name: {pt: "Disponibilidade", en: "Availability"},
          link: "prod.html#disponibilidade"
        },
        {
          name: {pt: "Suporte", en: "Support"},
          link: "prod.html#suporte"
        },
        {
          name: {pt: "Créditos", en: "Credits"},
          link: "prod.html#creditos"
        },
        {
          name: {pt: "Documentação", en: "Documentation"},
          link: "prod.html#sobre"
        },
        {
          name: {pt: "Publicações", en: "Publications"},
          link: "prod.html#publicacoes"
        },
        { link: "", name: {en: "" } },
        {
          name: {nl: "Copyright"},
          link: "copyright.html"
        },
        {
          name: {nl: "Download"},
          link: "download.html"
        },
        {
          name: {nl: "CVS"},
          link: "cvs.html"
        },
        {
          name: {pt: "Histórico", en: "History"},
          link: "history.html"
        },
        {
          name: {pt: "Pendências", en: "To Do"},
          link: "to_do.html"
        },
        {
          name: {nl: "Comparing"},
          link: "toolkits.html"
        },
        {
          name: {nl: "Screenshots"},
          link: "screenshots.html"
        }
      ]
    },
    {
      name: {en: "Guide"},
      link: "guide.html",
      folder:
      [
        {
          name: {en: "Getting Started"},
          link: "guide.html#start"
        },
        {
          name: {en: "Building Applications"},
          link: "guide.html#apl"
        },
        {
          name: {nl: "Building The Library"},
          link: "guide.html#buildlib"
        },
        {
          name: {nl: "Using IUP in C++"},
          link: "guide.html#cpp"
        },
        {
          name: {en: "Compilers"}, 
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "C++BuilderX"},
              link: "guide/cppbx.html"
            },
            {
              name: {nl: "Dev-C++"},
              link: "guide/dev-cpp.html"
            },
            {
              name: {nl: "Open Watcom C++"},
              link: "guide/owc.html"
            },
            {
              name: {nl: "Visual C++"},
              link: "guide/msvc.html"
            }
          ]
        },
        { link: "", name: {en: "" } },
        {
          name: {en: "Samples"},
          link: "samples.html"
        },
        {
          name: {nl: "CPI"},
          link: "cpi.html"
        }
      ]
    },
    { link: "", name: {en: "" } },
    {
      name: {en: "System"},
      link: "system.html",
      folder:
      [
        {
          name: {en: "Guide"},
          link: "sys_guide.html",
          folder:
          [
            {
              name: {en: "Initialization"},
              link: "sys_guide.html#init"
            },
            {
              name: {en: "IupLua Initialization"},
              link: "sys_guide.html#iupluainit"
            },
            {
              name: {nl: "LED"},
              link: "sys_guide.html#led"
            },
            {
              name: {nl: "IupLua"},
              link: "sys_guide.html#iuplua"
            },
            {
              name: {nl: "Other"},
              showdoc: "yes",
              folder:
              [
                {
                  name: {en: "LED Compiler for C"},
                  link: "ledc.html"
                },
                {
                  name: {en: "IupLua Advanced"},
                  link: "iuplua.html"
                }
              ]
            }
          ]
        },
        {
          name: {en: "Reference"},
          folder:
          [
            {
              name: {nl: "IupOpen"},
              link: "func/iupopen.html"
            },
            {
              name: {nl: "IupClose"},
              link: "func/iupclose.html"
            },
            {
              name: {nl: "iuplua_open"},
              link: "func/iuplua_open.html"
            },
            {
              name: {nl: "iupkey_open"},
              link: "func/iupkey_open.html"
            },
            {
              name: {nl: "IupVersion"},
              link: "func/iupversion.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupLoad"},
              link: "func/iupload.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupSetLanguage"},
              link: "func/iupsetlanguage.html"
            },
            {
              name: {nl: "IupGetLanguage"},
              link: "func/iupgetlanguage.html"
            }
          ]
        },
        {
          name: {nl: "Drivers"},
          folder:
          [
            {
              name: {nl: "Motif"},
              link: "drv/motif.html"
            },
            {
              name: {nl: "Win32"},
              link: "drv/win32.html"
            }
          ]
        }
      ]
    },
    {
      name: {en: "Attributes"},
      link: "attrib.html",
      folder:
      [
        {
          name: {en: "Guide"},
          link: "attrib_guide.html",
          folder:
          [
            {
              name: {nl: "Using"},
              link: "attrib_guide.html#Using"
            },
            {
              name: {nl: "Inheritance"},
              link: "attrib_guide.html#Inheritance"
            },
            {
              name: {nl: "IupLua"},
              link: "attrib_guide.html#IupLua"
            }
          ]
        },
        {
          name: {en: "Functions"},
          folder:
          [
            {
              name: {nl: "IupStoreAttribute"},
              link: "func/iupstoreattribute.html"
            },
            {
              name: {nl: "IupSetAttribute"},
              link: "func/iupsetattribute.html"
            },
            {
              name: {nl: "IupSetfAttribute"},
              link: "func/iupsetfattribute.html"
            },
            {
              name: {nl: "IupSetAttributes"},
              link: "func/iupsetattributes.html"
            },
            {
              name: {nl: "IupSetAttributeHan dle"},
              link: "func/iupsetattributehandle.html"
            },
            {
              name: {nl: "IupGetAttributeHandle"},
              link: "func/iupgetattributehandle.html"
            },
            {
              name: {nl: "IupGetAttribute"},
              link: "func/iupgetattribute.html"
            },
            {
              name: {nl: "IupGetAttributes"},
              link: "func/iupgetattributes.html"
            },
            {
              name: {nl: "IupGetFloat"},
              link: "func/iupgetfloat.html"
            },
            {
              name: {nl: "IupGetInt"},
              link: "func/iupgetint.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupStoreGlobal"},
              link: "func/iupstoreglobal.html"
            },
            {
              name: {nl: "IupSetGlobal"},
              link: "func/iupsetglobal.html"
            },
            {
              name: {nl: "IupGetGlobal"},
              link: "func/iupgetglobal.html"
            }
          ]
        },
        {
          name: {en: "Common"},
          folder:
          [
            {
              name: {nl: "ACTIVE"},
              link: "atrib/iup_active.html"
            },
            {
              name: {nl: "VISIBLE"},
              link: "atrib/iup_visible.html"
            },
            {
              name: {nl: "BGCOLOR"},
              link: "atrib/iup_bgcolor.html"
            },
            {
              name: {nl: "FGCOLOR"},
              link: "atrib/iup_fgcolor.html"
            },
            {
              name: {nl: "FONT"},
              link: "atrib/iup_font.html"
            },
            {
              name: {nl: "EXPAND"},
              link: "atrib/iup_expand.html"
            },
            {
              name: {nl: "X"},
              link: "atrib/iup_x.html"
            },
            {
              name: {nl: "Y"},
              link: "atrib/iup_y.html"
            },
            {
              name: {nl: "SIZE"},
              link: "atrib/iup_size.html"
            },
            {
              name: {nl: "WID"},
              link: "atrib/iup_wid.html"
            },
            {
              name: {nl: "TIP"},
              link: "atrib/iup_tip.html"
            },
            {
              name: {nl: "RASTERSIZE"},
              link: "atrib/iup_rastersize.html"
            },
            {
              name: {nl: "TITLE"},
              link: "atrib/iup_title.html"
            },
            {
              name: {nl: "VALUE"},
              link: "atrib/iup_value.html"
            },
            {
              name: {nl: "ZORDER"},
              link: "atrib/iup_zorder.html"
            },
            {
              name: {nl: "Motif"},
              showdoc: "yes",
              link: "drv/motif_attrib.html",
              folder:
              [
                {
                  name: {nl: "XDISPLAY"},
                  link: "drv/motif_attrib.html#XDISPLAY"
                },
                {
                  name: {nl: "XWINDOW"},
                  link: "drv/motif_attrib.html#XWINDOW"
                },
                {
                  name: {nl: "XSCREEN"},
                  link: "drv/motif_attrib.html#XSCREEN"
                }
              ]
            }
          ]
        },
        {
          name: {en: "Globals"},
          folder:
          [
            {
              name: {nl: "VERSION"},
              link: "atrib/iup_globals.html#version"
            },
            {
              name: {nl: "COPYRIGHT"},
              link: "atrib/iup_globals.html#copyright"
            },
            {
              name: {nl: "DRIVER"},
              link: "atrib/iup_globals.html#driver"
            },
            {
              name: {nl: "SYSTEM"},
              link: "atrib/iup_globals.html#system"
            },
            {
              name: {nl: "SYSTEMVERSION"},
              link: "atrib/iup_globals.html#systemversion"
            },
            {
              name: {nl: "SCREENSIZE"},
              link: "atrib/iup_globals.html#screensize"
            },
            {
              name: {nl: "SCREENDEPTH"},
              link: "atrib/iup_globals.html#screendepth"
            },
            {
              name: {nl: "LOCKLOOP"},
              link: "atrib/iup_globals.html#lockloop"
            },
            {
              name: {nl: "CURSORPOS"},
              link: "atrib/iup_globals.html#cursorpos"
            },
            {
              name: {nl: "COMPUTERNAME"},
              link: "atrib/iup_globals.html#computername"
            },
            {
              name: {nl: "USERNAME"},
              link: "atrib/iup_globals.html#username"
            },
            {
              name: {nl: "DLGBGCOLOR"},
              link: "atrib/iup_globals.html#DLGBGCOLOR"
            },
            {
              name: {en: "Win32"},
              showdoc: "yes",
              folder:
              [
                {
                  name: {nl: "HINSTANCE"},
                  link: "atrib/iup_globals.html#HINSTANCE"
                },
                {
                  name: {nl: "SYSTEMLANGUAGE"},
                  link: "atrib/iup_globals.html#SYSTEMLANGUAGE"
                },
                {
                  name: {nl: "DEFAULTFONT"},
                  link: "atrib/iup_globals.html#DEFAULTFONT"
                },
                {
                  name: {nl: "SHIFTKEY"},
                  link: "atrib/iup_globals.html#SHIFTKEY"
                },
                {
                  name: {nl: "CONTROLKEY"},
                  link: "atrib/iup_globals.html#CONTROLKEY"
                }
              ]
            },
            {
              name: {en: "Motif"},
              showdoc: "yes",
              folder:
              [
                {
                  name: {nl: "MOTIFVERSION"},
                  link: "atrib/iup_globals.html#MOTIFVERSION"
                },
                {
                  name: {nl: "TRUECOLORCANVAS"},
                  link: "atrib/iup_globals.html#TRUECOLORCANVAS"
                },
                {
                  name: {nl: "AUTOREPEAT"},
                  link: "atrib/iup_globals.html#AUTOREPEAT"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      name: {en: "Events"},
      link: "call.html",
      folder:
      [
        {
          name: {en: "Guide"},
          link: "call_guide.html",
          folder:
          [
            {
              name: {nl: "Using"},
              link: "call_guide.html#Using"
            },
            {
              name: {nl: "Main Loop"},
              link: "call_guide.html#mainloop"
            },
            {
              name: {nl: "IupLua"},
              link: "call_guide.html#IupLua"
            }
          ]
        },
        {
          name: {en: "Functions"},
          folder:
          [
            {
              name: {nl: "IupMainLoop"},
              link: "func/iupmainloop.html"
            },
            {
              name: {nl: "IupLoopStep"},
              link: "func/iuploopstep.html"
            },
            {
              name: {nl: "IupFlush"},
              link: "func/iupflush.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupGetCallback"},
              link: "func/iupgetcallback.html"
            },
            {
              name: {nl: "IupSetCallback"},
              link: "func/iupsetcallback.html"
            },
            {
              name: {nl: "IupGetActionName"},
              link: "func/iupgetactionname.html"
            },
            {
              name: {nl: "IupGetFunction"},
              link: "func/iupgetfunction.html"
            },
            {
              name: {nl: "IupSetFunction"},
              link: "func/iupsetfunction.html"
            }
          ]
        },
        {
          name: {en: "Common"},
          folder:
          [
            {
              name: {nl: "DEFAULT_ACTION"},
              link: "call/iup_default_action.html"
            },        
            {
              name: {nl: "IDLE_ACTION"},
              link: "call/iup_idle_action.html"
            },        
            { link: "", name: {en: "" } },
            {
              name: {nl: "GETFOCUS_CB"},
              link: "call/iup_getfocus_cb.html"
            },
            {
              name: {nl: "KILLFOCUS_CB"},
              link: "call/iup_killfocus_cb.html"
            },
            {
              name: {nl: "K_ANY"},
              link: "call/iup_k_any.html"
            },
            {
              name: {nl: "HELP_CB"},
              link: "call/iup_help_cb.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "ACTION"},
              link: "call/iup_action.html"
            }
          ]
        }
      ]
    },
    {
      name: {en: "Dialogs"},
      link: "dialogs.html",
      folder:
      [
        {
          name: {en: "Reference"},
          folder:
          [
            {
              name: {nl: "IupDialog"},
              link: "elem/iupdialog.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupDestroy"},
              link: "func/iupdestroy.html"
            },
            {
              name: {nl: "IupHide"},
              link: "func/iuphide.html"
            },
            {
              name: {nl: "IupMap"},
              link: "func/iupmap.html"
            },
            {
              name: {nl: "IupRefresh"},
              link: "func/iuprefresh.html"
            },
            {
              name: {nl: "IupPopup"},
              link: "func/iuppopup.html"
            },
            {
              name: {nl: "IupShow"},
              link: "func/iupshow.html"
            },
            {
              name: {nl: "IupShowXY"},
              link: "func/iupshowxy.html"
            }
          ]
        },
        {
          name: {en: "Predefined"},
          folder:
          [
            {
              name: {nl: "IupFileDlg"},
              link: "dlg/iupfiledlg.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupAlarm"},
              link: "dlg/iupalarm.html"
            },
            {
              name: {nl: "IupGetFile"},
              link: "dlg/iupgetfile.html"
            },
            {
              name: {nl: "IupGetText"},
              link: "dlg/iupgettext.html"
            },
            {
              name: {nl: "IupListDialog"},
              link: "dlg/iuplistdialog.html"
            },
            {
              name: {nl: "IupMessage"},
              link: "dlg/iupmessage.html"
            },
            {
              name: {nl: "IupScanf"},
              link: "dlg/iupscanf.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupGetColor"},
              link: "ctrl/iupgetcolor.html"
            },
            {
              name: {nl: "IupGetParam"},
              link: "ctrl/iupgetparam.html"
            }
          ]
        }
      ]
    },
    {
      name: {en: "Layout"},
      link: "layout.html",
      folder:
      [
        {
          name: {en: "Composition"},
          folder:
          [
            {
              name: {nl: "IupFill"},
              link: "elem/iupfill.html"
            },
            {
              name: {nl: "IupHbox"},
              link: "elem/iuphbox.html"
            },
            {
              name: {nl: "IupVbox"},
              link: "elem/iupvbox.html"
            },
            {
              name: {nl: "IupZbox"},
              link: "elem/iupzbox.html"
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupRadio"},
              link: "elem/iupradio.html"
            }
          ]
        },
        {
          name: {en: "Hierarchy"},
          folder:
          [
            {
              name: {nl: "IupAppend"},
              link: "func/iupappend.html"
            },
            {
              name: {nl: "IupDetach"},
              link: "func/iupdetach.html"
            },
            {
              name: {nl: "IupGetNextChild"},
              link: "func/iupgetnextchild.html"
            },
            {
              name: {nl: "IupGetBrother"},
              link: "func/iupgetbrother.html"
            },
            {
              name: {nl: "IupGetDialog"},
              link: "func/iupgetdialog.html"
            }
          ]
        }
      ]
    },
    {
      name: {en: "Controls"},
      link: "controls.html",
      folder:
      [
        {
          name: {en: "Standard"},
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "IupButton"},
              link: "elem/iupbutton.html"
            },
            {
              name: {nl: "IupCanvas"},
              link: "elem/iupcanvas.html"
            },
            {
              name: {nl: "IupFrame"},
              link: "elem/iupframe.html"
            },
            {
              name: {nl: "IupLabel"},
              link: "elem/iuplabel.html"
            },
            {
              name: {nl: "IupList"},
              link: "elem/iuplist.html"
            },
            {
              name: {nl: "IupMultiLine"},
              link: "elem/iupmultiline.html"
            },
            {
              name: {nl: "IupText"},
              link: "elem/iuptext.html"
            },
            {
              name: {nl: "IupToggle"},
              link: "elem/iuptoggle.html"
            }
          ]
        },
        {
          name: {en: "Additional"},
          link: "iupcontrols.html",
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "IupCbox"},
              link: "ctrl/iupcbox.html"
            },
            {
              name: {nl: "IupCells"},
              link: "ctrl/iupcells.html"
            },
            {
              name: {nl: "IupColorbar"},
              link: "ctrl/iupcolorbar.html"
            },
            {
              name: {nl: "IupColorBrowser"},
              link: "ctrl/iupcolorbrowser.html"
            },
            {
              name: {nl: "IupDial"},
              link: "ctrl/iupdial.html"
            },
            {
              name: {nl: "IupGauge"},
              link: "ctrl/iupgauge.html"
            },
            {
              name: {nl: "IupSbox"},
              link: "ctrl/iupsbox.html"
            },
            {
              name: {nl: "IupSpin"},
              link: "ctrl/iupspin.html"
            },
            {
              name: {nl: "IupTabs"},
              link: "ctrl/iuptabs.html"
            },
            {
              name: {nl: "IupVal"},
              link: "ctrl/iupval.html"
            },
            {
              name: {nl: "IupMatrix"},
              showdoc: "yes",
              link: "ctrl/iupmatrix.html",
              folder:
              [
                {
                  name: {nl: "Attributes"},
                  link: "ctrl/iupmatrix_attrib.html"
                },
                {
                  name: {nl: "Callbacks"},
                  link: "ctrl/iupmatrix_cb.html"
                }
              ]
            },
            {
              name: {nl: "IupTree"},
              showdoc: "yes",
              link: "ctrl/iuptree.html",
              folder:
              [
                {
                  name: {nl: "Attributes"},
                  link: "ctrl/iuptree_attrib.html"
                },
                {
                  name: {nl: "Callbacks"},
                  link: "ctrl/iuptree_cb.html"
                }
              ]
            },
            { link: "", name: {en: "" } },
            {
              name: {nl: "IupGLCanvas"},
              link: "ctrl/iupglcanvas.html"
            },
            {
              name: {nl: "IupOleControl"},
              link: "ctrl/iupole.html"
            },
            {
              name: {nl: "IupSpeech"},
              link: "ctrl/iupspeech.html"
            }
          ]
        }
      ]
    },
    {
      name: {en: "Keyboard"},
      link: "keyboard.html",
      folder:
      [
        {
          name: {en: "Codes"},
          link: "atrib/key.html"
        },
        {
          name: {en: "Reference"},
          folder:
          [
            {
              name: {nl: "IupNextField"},
              link: "func/iupnextfield.html"
            },
            {
              name: {nl: "IupPreviousField"},
              link: "func/iuppreviousfield.html"
            },
            {
              name: {nl: "IupGetFocus"},
              link: "func/iupgetfocus.html"
            },
            {
              name: {nl: "IupSetFocus"},
              link: "func/iupsetfocus.html"
            }
          ]
        }
      ]
    },
    {
      name: {en: "Resources"},
      link: "resources.html",
      folder:
      [
        {
          name: {en: "Menus"},
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "IupItem"},
              link: "elem/iupitem.html"
            },
            {
              name: {nl: "IupMenu"},
              link: "elem/iupmenu.html"
            },
            {
              name: {nl: "IupSeparator"},
              link: "elem/iupseparator.html"
            },
            {
              name: {nl: "IupSubmenu"},
              link: "elem/iupsubmenu.html"
            }
          ]
        },
        {
          name: {en: "Images"},
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "IupImage"},
              link: "elem/iupimage.html"
            },
            {
              name: {nl: "IupImageLib"},
              link: "ctrl/iupimglib.html"
            },
            {
              name: {nl: "Iup-IM"},
              link: "ctrl/iupim.html"
            }
          ]
        },
        {
          name: {en: "Names"},
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "IupSetHandle"},
              link: "func/iupsethandle.html"
            },
            {
              name: {nl: "IupGetHandle"},
              link: "func/iupgethandle.html"
            },
            {
              name: {nl: "IupGetName"},
              link: "func/iupgetname.html"
            },
            {
              name: {nl: "IupGetAllNames"},
              link: "func/iupgetallnames.html"
            },
            {
              name: {nl: "IupGetAllDialogs"},
              link: "func/iupgetalldialogs.html"
            }
          ]
        },
        {
          name: {en: "Fonts"},
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "IupMapFont"},
              link: "func/iupmapfont.html"
            },
            {
              name: {nl: "IupUnMapFont"},
              link: "func/iupunmapfont.html"
            },
            {
              name: {en: "Predefined Fonts"},
              link: "atrib/font.html"
            }
          ]
        },
        {
          name: {nl: "IupTimer"},
          link: "elem/iuptimer.html"
        },
        {
          name: {nl: "IupUser"},
          link: "elem/iupuser.html"
        },
        { link: "", name: {en: "" } },
        {
          name: {nl: "IupGetType"},
          link: "func/iupgettype.html"
        },
        {
          name: {nl: "IupHelp"},
          link: "func/iuphelp.html"
        },
        {
          name: {nl: "iupMask"},
          link: "ctrl/iupmask.html",
          showdoc: "yes",
          folder:
          [
            {
              name: {nl: "Pattern Specification"},
              link: "ctrl/iupmask_masks.html"
            }
          ]
        }
      ]
    }
  ]
};
