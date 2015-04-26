var fullLocation = function(address, city, state, zip) {
  return address + '\n' + city + ', ' + state + ' ' + zip;
};

var EventForm = React.createClass ({
  handleSubmit: function(e) {
    e.preventDefault();
    e.stopPropagation();

    /* this.refs.x.getDOMNode().value.trim() extracts the value of x from a form */
    var name = this.refs.name.getDOMNode().value.trim();

    /* Start and End times will be more complicated - just a placeholder */
    var startTime = this.refs.startTime.getDOMNode().value.trim();
    var endTime = this.refs.endTime.getDOMNode().value.trim();

    var venueName = this.refs.organization.getDOMNode().value.trim();

    var address = this.refs.address.getDOMNode().value.trim();
    var city = this.refs.address.getDOMNode().value.trim();
    var state = this.refs.state.getDOMNode().value.trim();
    var zip = this.refs.zip.getDOMNode().value.trim();

    var description = this.refs.description.getDOMNode().value.trim();
    var howToFindUs = this.refs.howToFindUs.getDOMNode().value.trim();

    /* Refer to schema.rb for keys. Values are the variables set above. */
    this.props.onEventSubmit({name: name, start: startTime, end: endTime,
      venue_name: venueName, address_1: address, city: city,
      state: state, zip: zip, description: description,
      how_to_find_us: howToFindUs});
  },

  render: function() {
    return (
      <div>
        <div id="invalid_form_warnings">
          {/* gotta somehow put flash messages here...? */}
          <p><i>invalid submission errors will appear here</i></p>
        </div>

        <form onSubmit={this.handleSubmit}>
        <div id="e_name">
          <label htmlFor="event_name">Name</label><br/>
          <input type="text" defaultValue={this.props.name} placeholder="Name" name="event[name]" id="edit_name" className="edit_text_field" ref='name'/>
        </div>

        <div id="e_start_date">
          <label htmlFor="event_start_date">Start Date</label><br/>
          <input type="text" defaultValue={this.props.start_month} placeholder="Month" name="event[start(month)]" id="edit_start_month" className="edit_text_field" style={{width: '37%'}} ref='month'/>
          {' '}
          <input type="text" defaultValue={this.props.start_day} placeholder="Day" name="event[start(day)]" id="edit_start_day" className="edit_text_field" style={{width: '2em'}} ref='start_day'/>
          {', '}
          <input type="text" defaultValue={this.props.start_year} placeholder="Year" name="event[start(year)]" id="edit_start_year" className="edit_text_field" style={{width: '3em'}} ref='start_year'/>
{/*          <select id="event_start_month" name="event[start(month)]" defaultValue={this.props.start_month} className="drop_down"/>
          {' '}
          <select id="event_start_day" name="event[start(day)]" defaultValue={this.props.start_day} className="drop_down"/>
          {', '}
          <select id="event_start_year" name="event[start(year)]" defaultValue={this.props.start_year} className="drop_down"/>
*/}
        </div>

        <div id="e_start_time">
          <label htmlFor="event_start_time">Start Time</label><br/>
          <input type="text" defaultValue={this.props.start_hour} placeholder="Hr" name="event[start(hour)]" id="edit_start_hour" className="edit_text_field" style={{width: '2em'}}/>
          {' : '}
          <input type="text" defaultValue={this.props.start_minute} placeholder="Min" name="event[start(minute)]" id="edit_start_minute" className="edit_text_field" style={{width: '2em'}}/>
          {' '}
          <input type="text" defaultValue={this.props.start_ampm} placeholder="a/p" name="event[start(ampm)]" id="edit_start_ampm" className="edit_text_field" style={{width: '2em'}}/>
{/*          <select id="event_start_hour" name="event[start(hour)]" defaultValue={this.props.start_hour} className="drop_down"/>
          {' : '}
          <select id="event_start_minute" name="event[start(minute)]" defaultValue={this.props.start_minute} className="drop_down"/>
          {' '}
          <select id="event_start_ampm" name="event[start(ampm)]" defaultValue={this.props.start_ampm} className="drop_down"/>
*/}
        </div>

        <div id="e_end_date">
          <label htmlFor="event_end_date">End Date</label><br/>
          <input type="text" defaultValue={this.props.end_month} placeholder="Month" name="event[end(month)]" id="edit_end_month" className="edit_text_field" style={{width: '37%'}}/>
          {' '}
          <input type="text" defaultValue={this.props.end_day} placeholder="Day" name="event[end(day)]" id="edit_end_day" className="edit_text_field" style={{width: '2em'}}/>
          {', '}
          <input type="text" defaultValue={this.props.end_year} placeholder="Year" name="event[end(year)]" id="edit_end_year" className="edit_text_field" style={{width: '3em'}}/>
{/*          <select id="event_end_month" name="event[end(month)]" defaultValue={this.props.end_month} className="drop_down"/>
          {' '}
          <select id="event_end_day" name="event[end(day)]" defaultValue={this.props.end_day} className="drop_down"/>
          {', '}
          <select id="event_end_year" name="event[end(year)]" defaultValue={this.props.end_year} className="drop_down"/>
*/}
        </div>

        <div id="e_end_time">
          <label htmlFor="event_end_time">End Time</label><br/>
          <input type="text" defaultValue={this.props.end_hour} placeholder="Hr" name="event[end(hour)]" id="edit_end_hour" className="edit_text_field" style={{width: '2em'}}/>
          {' : '}
          <input type="text" defaultValue={this.props.end_minute} placeholder="Min" name="event[end(minute)]" id="edit_end_minute" className="edit_text_field" style={{width: '2em'}}/>
          {' '}
          <input type="text" defaultValue={this.props.end_ampm} placeholder="a/p" name="event[end(ampm)]" id="edit_end_ampm" className="edit_text_field" style={{width: '2em'}}/>
{/*          <select id="event_end_hour" name="event[end(hour)]" defaultValue={this.props.end_hour} className="drop_down"/>
          {' : '}
          <select id="event_end_minute" name="event[end(minute)]" defaultValue={this.props.end_minute} className="drop_down"/>
          {' '}
          <select id="event_end_ampm" name="event[end(ampm)]" defaultValue={this.props.end_ampm} className="drop_down"/>
*/}
        </div>

        <div id="e_location">
          <label htmlFor="event_location">Location</label><br/>
          <input type="text" defaultValue={this.props.location_street} placeholder="Street" name="event[location(street)]" id="edit_location_street" className="edit_text_field" style={{margin: '0 0 0.3em 0'}}/><br/>
          <input type="text" defaultValue={this.props.location_city} placeholder="City" name="event[location(city)]" id="edit_location_city" className="edit_text_field" style={{width: '50%'}}/>
          {', '}
          <input type="text" defaultValue={this.props.location_state} placeholder="State" name="event[location(state)]" id="edit_location_state" className="edit_text_field" style={{width: '2.5em'}}/>
{/*          <select id="event_location_state" name="event[location(state)]" defaultValue={this.props.location_state} className="drop_down"/>
*/}
        </div>

        <div id="e_description">
          <label htmlFor="edit_description">Description</label><br/>
          {/*<form method="post">
            <textarea defaultValue={this.props.description} placeholder="Description" name="event[description]" id="edit_description" className="edit_text_field" style={{height: '9em'}}/>
          </form> */}
          {/* this is a hacky html5 not true rich text editor...needs work, but does support copy/paste from ms word, no idea how to save... */}
          <div id="edit_description" dangerouslySetInnerHTML={{__html: this.props.description}} contentEditable="true" className="edit_text_field"/>
        </div>

        <div style={{float: 'right'}}>
          <input type="submit" className="button" value="save" />
        </div>
        </form>
      </div>
    )
  }
});

var EditEvent = React.createClass ({
  handleEventSubmit: function(event) {
    $.ajax({
      url: '/events/' + this.props.calEvent.id,
      dataType: 'json',
      type: 'PUT',
      data: {'event': event},
      success: function(data) {
        var timePeriod = timePeriod(moment(event.start), moment(event.end));
        var loc = fullLocation(event.address_1, event.city, event.state, event.zip);
        React.render(
          <div>
            <Event title={event.name} timePeriod={timePeriod} location={loc} description={event.description}/>
            <AdminButtons calEvent={calEvent}/>
          </div>,
          document.getElementById('panel')
        );
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/events/' + this.props.calEvent.id, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    return (
      <EventForm onEventSubmit={this.handleEventSubmit}/>
    );
  }
});

/* Image form code

        <div id="e_image">
          <label htmlFor="edit_image">Image</label><br/>
          <p><i>should display image file name here if one has already been uploaded</i></p><br/>
          <form className="edit_event" id="edit_image" encType="multipart/form-data" acceptCharset="UTF-8" method="post">
            <input name="utf8" type="hidden" value="&#x2713;"/>
            <input type="hidden" name="_method" value="patch"/>
            <input type="hidden" name="authenticity_token" value="TLrlBDUtqMELfBt0N9+mAF29VV5T5RQifcEgHtT76m9TG0B7KSaWV0lajswzrcgZCGsc3a569Oo6vfLx69SKgQ=="/>
            <input id="image" type="file" name="event[image]"/>
            <input type="submit" name="commit" value="Upload"/>
          </form>
        </div>
        <br/><br/>
*/
