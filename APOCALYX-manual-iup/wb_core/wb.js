
cur_topic = "vazio"

function start_page()
{
  var ss = document.URL;
 
  if (ss != null)
  {
    var contents = null;
    var book = null;
    var start = null;
    var sData = ss.substring(ss.indexOf("?") + 1, ss.length);
    aData = sData.split("&");
    for(var i = 0; i<aData.length; i++)
    {
      var sName = aData[i].substring(0,aData[i].indexOf("="));
      var sValue = aData[i].substring(aData[i].indexOf("=")+1, aData[i].length);
      if (sName == "contents")
        contents = unescape(sValue);
      if (sName == "book")
        book = unescape(sValue);
      if (sName == "url")
        start = unescape(sValue);
    }

    if(start != null)
    {
      var index = wb_tree.find_topic(start)
      if (index != null)
      {
        parent.set_topic(index)
        return
      }
    }
    else if(contents != null)
    {
      if(book != null)
      {
        wb_load(contents, book);
        wb_sync(contents, book);
        return
      }
      else
      {
        wb_load(contents);
        wb_sync(contents);
        return
      }
    }
  }
  wb_tree.home();
}

// Returns the id of the current topic
function get_topic()
{
  return cur_topic
}

// Sets current topic based on the index
function set_topic(index, dont_change)
{
  // Changes the page
  var topic = wb_tree.indexOfEntries[index]
  if(dont_change == null)
  {
    if(topic != null)
    {
      if(topic.hreference != null)
      {
        var link = topic.hreference     
        if (link != "")
          parent.wb_cont.location.href = wb_tree.MakeLink(link)
      }
    }
  }
  
  // Tree must be opened
  wb_tree.assertOpen(topic)  
  
  // Deals selection of node
  wb_tree.switchSelection(index, cur_topic)

  // Sets topic
  cur_topic = index
}

// Changes current language (reload everything)
function wb_chlang()
{
  if (parent.wb_usr.langs.length == 1)
    return;
  
  // Returns to the beggining of language index if all languages have been chosen
  if (parent.wb_cur_lang_index < parent.wb_usr.langs.length-1)
    parent.wb_cur_lang_index++;
  else
    parent.wb_cur_lang_index = 0;
  
  parent.wb_cur_lang = parent.wb_usr.langs[parent.wb_cur_lang_index];

  var layer = parent.wb_bar._wb_get_layer("layer0");
  
  // Reloading each part separately (we cannot reset parent.wb_cur_lang)
  parent.wb_tree.location.reload(); // Automatically reloads first page
  parent.wb_bar._wb_update_lang(layer);
  parent.wb_title.location.reload();
  parent.document.title = parent.wb_usr.messages[parent.wb_cur_lang].title;
}

function wb_old_link(contents, book)
{
  var link = contents+".html"
  if(book != null)
    link = link + "#" + book
  return link
}

// For backward compatibility with Webbook 1.0
function wb_load(contents, book) 
{
  var link = wb_old_link(contents, book)  
  var index = wb_tree.find_topic(link)
  if (index != null)
    parent.set_topic(index)
  else
    parent.wb_cont.location.href = link
}

// For backward compatibility with Webbook 1.0
function wb_sync(contents, book)
{
  link = wb_old_link(contents, book)
  var index = wb_tree.find_topic(link)
  if (index != null)
    parent.set_topic(index)
  else
    parent.wb_cont.location.href = link
}

// For backward compatibility with ManJs
function manLoadCont(name, contents, book)
{
  wb_load(contents, book)
}

function wb_topic(link)
{
  var index = parent.wb_tree.find_topic(link)
  if (index != null)
    parent.set_topic(index)
}