import React from 'react';
import './App.css';
import {TimeSeriesChart} from "./TimeSeriesChart";
import {EFayeChannel} from "./EFayeChannel";

const App: React.FC = () => {
  return (
    <div className="App">
        <TimeSeriesChart channel={EFayeChannel.TIMESERIES}/>
    </div>
  );
};

export default App;
