/** @jsx React.DOM */
var displayEventPanel = function() {
  return (
    <div>
      <h2 style={{fontWeight: 200}}>Event Details</h2>
      <div id="image">
        <i>image resizing has to be done, maybe to resize along with page size?</i>
        // image here
      </div>
      <br/>
      <div id="name">
        <div className="left">
          <p>What</p>
        </div>
        <div className="right">
          <p>
            {this.props.name}
          </p>
        </div>
        <div style={{clear: 'both'}}></div>
      </div>
      <div id="date_time">
        <div className="left">
          <p>When</p>
        </div>
        <div className="right">
          <p>
            {this.props.start} to {this.props.end}
          </p>
        </div>
        <div style={{clear: 'both'}}></div>
      </div>
      <div id="location">
        <div className="left">
          <p>Where</p>
        </div>
        <div className="right">
          <p>
            {this.props.location}
          </p>
          <p>
            <i>map may be coming soon!</i>
          </p>
        </div>
        <div style={{clear: 'both'}}></div>
      </div>
      <br/>
      <div id="description">
        {this.props.description}
      </div>
      <br/>
      <br/>
      <div id="rsvp">
        <i>rsvp under construction</i>
        // maybe we should put a link to an rsvp form page or popup...
      </div>
      <br/>
      <br/>
      <div id="crud"></div>
      /* if @current user, then show edit and delete button */
    </div>
  );
}

var Event = React.createClass({
  loadEventsFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(events) {
        this.setState({events: events});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  handleEventSubmit: function(event) {
    var events = this.state.events;
    var newEvents = events.concat([event]);
    this.setState({events: newEvents});
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      type: 'POST',
      data: {'event': event},
      success: function(data) {
        this.loadEventsFromServer();
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  render: displayEventPanel
});
