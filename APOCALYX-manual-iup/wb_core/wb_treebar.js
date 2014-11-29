//
// Tree access functions
//
// Mark Stroetzel Glasberg <mark@tecgraf.puc-rio.br>
//

// Expands all branches 
function exp_all()
{
  var i = 0;
  while(i<=nEntries)
  {
    var clickedFolder = indexOfEntries[i];
    if (clickedFolder != null && clickedFolder.isOpen != null)
    {
      state = clickedFolder.isOpen;
      if(state != null && state == 0)
        clickedFolder.setState(1); //open
    }
    i++;
  }
}

// Closes all branches (except the root)
function cont_all()
{
  closeFolders()
}

// Walks forward in the tree
function next()
{
  if(parent.get_topic() >= nEntries-1)
    return;
  else
    parent.set_topic(parent.get_topic() + 1);
}

// Walks backwards in the tree
function previous()
{
  if(parent.get_topic() <= 0)
    return;
  else
    parent.set_topic(parent.get_topic() - 1);
}

function home()
{
  parent.set_topic(0);
}

function match_filename(link)
{
  if(link != null)
  {
    // Not inside a dir
    var index = link.lastIndexOf("\/")

    if(index == -1)
      return link
    
    //var r = link.match(/^.*\/(.*)$/) //old
    return link.substr(index+1, link.length)
  }
  return null
}

// Finds a topic based only on filename and bookmark (ignores subdirectories)
// Also, returns the first file that matches description (if the same file is used
// multiple times, the first item will always be returned
function find_topic(topic)
{
  var i = 0;
  var topic = match_filename(topic)
  
  if(topic != null)
  {
    while(topic != null && i<= nEntries)
    {
      var t = indexOfEntries[i];
      if(t != null)
      {
        var href = t.hreference
        if(href != null)
        {
          href = match_filename(href)
          if(href != null && href == topic)
            return i
        }
      }
      i++;
    }
  }
  return null
}

// Finds the topic on display in the tree and sets it as current.
function sync()
{
  var cur_topic = parent.wb_cont.location.href
  var t = find_topic(cur_topic)
  if (t != null)
    parent.set_topic(t, 1)
}

function site_map()
{            
  parent.wb_cont.location.href = "wb_map.html"
}

function MakeLink2(link)
{
  if(link.substring(0, 5) == "http:")
    return link
  else
    return parent.wb_cur_lang + "/" + link
}

function build_map()
{
  var i = 0;     
  var cdoc = parent.wb_cont.document;
  
  while(i<parent.wb_tree.nEntries)
  {
    var topic = parent.wb_tree.indexOfEntries[i];
    var link = topic.hreference;                                                 
    var prevLevel = 0
    if (link != "" && link != null)
    {                                
      var link_url = parent.wb_tree.MakeLink2(link);
      
      if (topic.treeLevel == 0)
        cdoc.write("<h2>")
      else if (topic.treeLevel == 1)
        cdoc.write("</blockquote><h3>")
        
      cdoc.write("<a href='../"+link_url+"'>"+ topic.desc+" - "+link_url+"</a><br>"); 
      
      if (topic.treeLevel == 0)
        cdoc.write("</h2>")
      else if (topic.treeLevel == 1)
        cdoc.write("</h3><blockquote>")
    }
    i++;
  }
}
