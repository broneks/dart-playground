import 'dart:html';
import 'dart:convert' show JSON;
import 'dart:async' show Future;

Element article;
Element title;
Element year;
Element genre;
Element rating;
Element desc;
Element director;
Element stars;
ImageElement poster;
SelectElement moviesSelect;

void main() {
    article  = querySelector('article');
    title    = querySelector('.title');
    year     = querySelector('.year');
    genre    = querySelector('.genre');
    rating   = querySelector('.rating');
    desc     = querySelector('.description');
    director = querySelector('.director');
    stars    = querySelector('.stars');
    poster   = querySelector('img');
    moviesSelect = querySelector('#movies');
    
    Movie.getMovies();
    
    querySelector('#movies').onInput.listen(viewSelected);
}

void populateSelect(List movies) {
    
    for (var movie in movies) {
        int index  = movies.indexOf(movie);
        var option = new OptionElement();
        
        option.text  = movie['title'];
        option.value = index.toString();
        
        moviesSelect.children.add(option);  
    }
}

void viewSelected(Event e) {
    int index = int.parse((e.target as SelectElement).value);
    
    if (index >= 0) {
        Movie.dataByIndex(index);
        
    } else {
        print('Please select a movie.');
    }
}

void showArticle() {
    article.classes.add('show');
}

void showDetails(Map movie) {
    title.text    = movie['title'];
    genre.text    = movie['genre'];
    rating.text   = movie['rating'].toString();
    desc.text     = movie['description'];
    director.text = movie['crew']['director'];
    
    String yearStr = movie['year'].toString();
    year.text = '($yearStr)';
    
    String imgSrc = movie['poster'];
    poster.src = 'img/$imgSrc';
    
    String starsStr = movie['crew']['stars']
                        .toString()
                        .replaceAll(new RegExp('[\\[\\]]'), '');
    stars.text = starsStr;
    
    showArticle();
}

class Movie {
    static Map _movies;
    
    static Future getMovies() {
        var path = 'movies.json';
        
        return HttpRequest.getString(path)
            .then(_parseJSON);
    }
    
    static _parseJSON(String data) {
        _movies = JSON.decode(data);
        
        populateSelect(_movies['data']);
    }
    
    static dataByIndex(int index) {
        if (index.isNaN) return;
        
        var data = _movies['data'][index];
        
        showDetails(data);
    }
}