/** @jsx React.DOM */
var Event = React.createClass({
  render: function() {
    return (
      <div>
        <div id="image">
          <i>image resizing has to be done, maybe to resize along with page size?</i>
          {/* image here */}
        </div>
        <br/>

        <div id="name">
          <div className="left">
            <p>What</p>
          </div>
          <div className="right">
            <p>
              {this.props.title}
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
              {this.props.timePeriod}
            </p>
          </div>
          <div style={{clear: 'both'}}></div>
        </div>

        <div id="location">
          <div className="left">
            <p>Where</p>
          </div>
          <div className="right" style={{whiteSpace: 'pre-wrap'}}>
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

        <div id="description" dangerouslySetInnerHTML={{__html: this.props.description}}/>
        <br/>
        <br/>

        <div id="rsvp">
          <i>rsvp under construction</i>
          {/* maybe we should put a link to an rsvp form page or popup... */}
        </div>
        <br/>
        <br/>
      </div>
    );
  }
});

var AdminButtons = React.createClass({
  handleDelete: function() {
    $.ajax({
      url: '/events/' + this.props.calEvent.id,
      type: 'DELETE',
      success: function(data) {
        React.render(
          <p id='deleteMsg'>{this.props.calEvent.title} was successfully removed.</p>,
          document.getElementById('panel')
        );
        $('#calendar').fullCalendar('removeEvents', this.props.calEvent.id);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/events/' + this.props.calEvent.id, status, err.toString());
      }.bind(this)
    });
    return false;
  },

  handleUpdateLink: function() {
    var calEvent = this.props.calEvent;
    var startTime = calEvent.start.format('MMMM Do YYYY, h:mm a');
    var start_month  = calEvent.start.format('MMMM');
    var start_day    = calEvent.start.format('D');
    var start_year   = calEvent.start.format('YYYY');
    var start_hour   = calEvent.start.format('h');
    var start_minute = calEvent.start.format('mm');
    var start_ampm   = calEvent.start.format('a');
    var endTime;
    var eventEnd = calEvent.end;
    if (eventEnd == null) {
      endTime = null;
    } else {
      var end_month  = calEvent.end.format('MMMM');
      var end_day    = calEvent.end.format('D');
      var end_year   = calEvent.end.format('YYYY');
      var end_hour   = calEvent.end.format('h');
      var end_minute = calEvent.end.format('mm');
      var end_ampm   = calEvent.end.format('a');
    }
    var locationDetails = calEvent.location.split("\n");
    var location_street = locationDetails[0];
    var location_city   = locationDetails[1].split(", ")[0];
    var location_state  = locationDetails[1].split(", ")[1];

    React.render(
      <EditEvent event_id={calEvent.id} name={calEvent.title} start_month={start_month} start_day={start_day} start_year={start_year} start_hour={start_hour} start_minute={start_minute} start_ampm={start_ampm} end_month={end_month} end_day={end_day} end_year={end_year} end_hour={end_hour} end_minute={end_minute} end_ampm={end_ampm} location_street={location_street} location_city={location_city} location_state={location_state} description={calEvent.description}/>,
      document.getElementById('panel')
    );
    return false;
  },

  render: function() {
    return (
      <div>
        <i>these buttons will only be visible to admin</i>
        <div>
          <form onSubmit={this.handleUpdateLink}>
            <input id='eventEditLink' className='button' style={{float: 'left'}} type='submit' value='Edit'/>
          </form>
          <form onSubmit={this.handleDelete}>
            <input id='eventDelete' className='button' style={{float: 'right'}} type='submit' value='Delete'/>
          </form>
        </div>
      </div>
    );
  }
});
