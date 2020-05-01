/* custom file for eades microservices api first lab */
package swagger

import (
	"fmt"
	"log"
	"net/http"
	"io/ioutil"
	"html/template"
)
func GetAllNews(w http.ResponseWriter, r *http.Request) {
	urls := [2]string{"http://nftch:8888", "http://wftch:8888" }
	
	w.Header().Set("Content-Type", "text/html; charset=utf-8")

	// PROCESSING STAGE 1
	// Get information from news and weather services
	infoTypes := [2]string{ "news", "weather"}
	var fetchedStrings [2]string = [2]string{"", ""}
	for i := 0; i < 2; i++ {
		resp, err := http.Get(urls[i])
		if (err != nil) {
			fmt.Fprintln(w, "allthenews[ERROR]: Couldn't get " + infoTypes[i] + " from site. " + err.Error() + "<br/>")
			log.Printf("allthenews[ERROR]: Couldn't get " + infoTypes[i] + " from site. " + err.Error())
		} else {
			if resp.StatusCode == http.StatusOK {
				bodyBytes, err2 := ioutil.ReadAll(resp.Body)
				if (err2 != nil) {
					fmt.Fprintln(w, "allthenews[ERROR]: Couldn't get " + infoTypes[i] + " from response." + 					err2.Error() + "<br/>")
					log.Printf("allthenews[ERROR]: Couldn't get " + infoTypes[i] + " from response." + 					err2.Error())
				} else {
					fetchedStrings[i] = string(bodyBytes)
				}
			} else {
				fmt.Fprintln(w, "allthenews[ERROR]: HTTP returned status " + string(resp.StatusCode) + "<br/>")
				log.Printf("allthenews[ERROR]: HTTP returned status " + string(resp.StatusCode))
			}
		}
	}

	// Create the inserts for the HTML file, which is only a skeleton with no information.
	inserts := struct {
    		News string
		Weather string	
	}{
    		fetchedStrings[0],
		fetchedStrings[1],
	}

	// PROCESSING STAGE 2
	// Read the query parameter "style" and check it against the different allowed values, assigning
	// the appropriate template name to variable templateName.	
	var templateName = ""
	switch r.URL.Query().Get("style") {
	case "plain":
		templateName = "plain.html"
	case "colourful":
		templateName = "colour.html"
	case "blackandwhite":
		templateName = "bandw.html"
	}

	// PROCESSING STAGE 3
	// We are using the template handling library html/template to insert the information fetches from the other
	// services into the page with the requested style (via parameter 'style').
	if (templateName != "") {
		// Now put together an HTML page. The template.ParseFiles() function inserts the values from structure
		// 'inserts' into the chosen template.
		t, _ := template.ParseFiles(templateName)
		t.Execute(w, inserts)
	} else {
		fmt.Fprintln(w, "allthenews[ERROR]: Invalid style parameter.<br>")
		log.Printf("allthenews[ERROR]: Invalid style parameter.")
	}
}
