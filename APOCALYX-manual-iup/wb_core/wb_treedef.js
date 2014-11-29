
//
// Builds the tree based on wb_usr description
//
//
// Mark Stroetzel Glasberg <mark@tecgraf.puc-rio.br>
//

// Decide if the names are links or just the icons
USETEXTLINKS = 1

//if the gif's folder is a subfolder, for example: 'images/'
ICONPATH = 'wb_img/' 

function MakeLink(link)
{
  if(link.substring(0, 5) == "http:")
    return link
  else
    return parent.START_URL + "/" + parent.wb_cur_lang + "/" + link
}

function GetLink(obj)
{
  if (obj.link != null)
    return obj.link
  else
    return null
}

function GetName(obj)
{
  if(obj != null && obj.name != null)
  {
    if (parent.wb_cur_lang != null && obj.name[parent.wb_cur_lang] != null)
      return obj.name[parent.wb_cur_lang]
    else if(obj.name["nl"])
      return obj.name["nl"]
    else
      return obj.name
  }
  else
    return ""    
}

function TreeSetValue(t, tree)
{
  if (t == null) 
    return
  if (tree == null) // First time in here
    tree = gFld(GetName(t), GetLink(t), "../wb_usr/root.gif") //# mudar aqui!!
  var cont = 0
  var children = GetChild(t)
  while(children != null && cont < children.length)
  {
    var a = children[cont]
    if(IsFolder(a))
    {
      var folder = gFld(GetName(a), GetLink(a))
      folder.showDoc = a.showdoc
      insFld(tree, folder)
      TreeSetValue(a, folder)
    }
    else
      insDoc(tree, gLnk(GetName(a), GetLink(a)))
    cont++
  }
  return tree
}

function IsFolder(obj)
{
  if(obj == null || obj.folder == null)
    return 0
  else
    return 1
}

function GetChild(obj)
{
  return obj.folder
}

function TreeInit()
{  
  // Use can choose to use icons in folders and nodes
  if (parent.wb_usr != null && parent.wb_usr.use_items != null && parent.wb_usr.use_items == "no")
    USE_ITEMS = 0
  else
    USE_ITEMS = 1
  
  if (parent.wb_usr != null && parent.wb_usr.use_folders != null && parent.wb_usr.use_folders == "yes")
    USE_FOLDERS = 1
  else
    USE_FOLDERS = 0
}

/* The tree will be created from the given table */
foldersTree = TreeSetValue(parent.wb_usr.tree)
TreeInit()
