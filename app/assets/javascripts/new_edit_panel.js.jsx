var form = function() {
}

var newPanel = React.createClass({
  handleSubmit: function() {
    var name = this.refs.name.getDOMNode().value.trim();
    var start = this.refs.start.getDOMNode().value.trim();
    var end = this.refs.end.getDOMNode().value.trim();
    var address_1 = this.refs.address_1.getDOMNode().value().trim();
    var city = this.refs.city.getDOMNode().value().trim();
    var state = this.refs.state.getDOMNode().value().trim();
    var zip = this.refs.zip.getDOMNode().value().trim();
    var country = this.refs.country.getDOMNode().value().trim();
    var description = this.refs.description.getDOMNode().value.trim();

    this.props.onEventSubmit({title: title, start: start});

    this.refs.name.getDOMNode().value = '';
    this.refs.start.getDOMNode().value = '';
    this.refs.end.getDOMNode().value = '';
    this.refs.address_1.getDOMNode().value = '';
    this.refs.city.getDOMNode().value = '';
    this.refs.state.getDOMNode().value = '';
    this.refs.zip.getDOMNode().value = '';
    this.refs.country.getDOMNode().value = '';
    this.refs.description.getDOMNode().value = '';
    return false;
  },

  render: form
});
