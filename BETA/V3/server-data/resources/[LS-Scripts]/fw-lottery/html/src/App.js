import React, { Component } from 'react';

import API from './Classes/API';

import './App.scss';

import ScratchBlock from './Components/ScratchBlock';
import ScratchBg from './assets/images/scratch_bg.jpg';

class App extends Component {

  constructor(props) {
    super(props);

    this.showCard = this.showCard.bind(this);
    this.hideCard = this.hideCard.bind(this);

    this.state = {
      display: false,
      scratchComplete: false,
      block1: "",
      block2: "",
      block3: "",
      serial: ""
    };
  }

  componentDidMount() {
    window.addEventListener( 'cagescratchShow', this.showCard );
    window.addEventListener( 'cagescratchHide', this.hideCard );

    var instance = this;

    // catch escape and backspace
    document.onkeydown = function(evt) {
        evt = evt || window.event;
        if (evt.keyCode == 27 || evt.keyCode == 8) {
            if(instance.state.scratchComplete === true) {
              instance.hideCard();
            }
        }
    };

    // catch rmb
    window.oncontextmenu = function () {
      if(instance.state.scratchComplete === true) {
        instance.hideCard();
      }
    }

  }

  componentWillUnmount() {
    window.removeEventListener( 'cagescratchShow', this.showCard );
    window.removeEventListener( 'cagescratchHide', this.hideCard );
  }

  showCard(cEvent) {
    this.setState({
      display: true,
      scratchComplete: false,
      block1: cEvent.detail.blocks.block1,
      block2: cEvent.detail.blocks.block2,
      block3: cEvent.detail.blocks.block3,
      serial: cEvent.detail.serial
    });
  }

  hideCard(cEvent) {
    API.cardClosed();

    this.setState({
      display: false,
      scratchComplete: false,
      block1: "",
      block2: "",
      block3: "",
      serial: ""
    });

  }

  render() {

    if(!this.state.display) {
      return(<div></div>);
    }

    var shouldDisplay = (this.state.display?"block":"none");

    return (
      <div className="App" style={{display:shouldDisplay}} id="App">
        <div className="ScratchCard" style={{backgroundImage: "url("+ScratchBg+")"}}>
          <ScratchBlock serial={this.state.serial} block1={this.state.block1} block2={this.state.block2} block3={this.state.block3} onScratchComplete={() => {this.setState({scratchComplete: true})}} />
          <div className="SerialNumber">
            <span>{this.state.serial}</span>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
