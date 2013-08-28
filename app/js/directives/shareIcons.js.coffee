@prepTickets.directive('shareIcons', () ->
  restrict: 'E' 
  replace: true
  scope: 
    waitTill: "="
  template: '<div class="share-icons"><!-- AddThis Button BEGIN -->
              <div addthis-toolbox wait-till="waitTill" class="addthis_toolbox addthis_default_style">
              <a class="addthis_button_facebook_like" fb:like:layout="button_count"></a>
              <a class="addthis_button_tweet"></a>
              <a class="addthis_button_google_plusone" g:plusone:size="medium"></a>
              <a class="addthis_counter addthis_pill_style"></a>
              </div>
              <!-- AddThis Button END -->
            </div>'
)