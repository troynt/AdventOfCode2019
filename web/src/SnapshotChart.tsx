import React from "react";
import {FayeStore} from "./stores/FayeStore";

import ReactEcharts from "echarts-for-react";
import {observer} from "mobx-react";
import {action, computed, observable} from "mobx";
import {EFayeChannel} from "./EFayeChannel";

interface SnapshotChartProps {
    channel: EFayeChannel;
}

interface EchartData {
    a: number,
    b: number
}

@observer
export class SnapshotChart extends React.Component<SnapshotChartProps> {
    @observable
    private faye: FayeStore<EchartData, { title: string }>;

    componentDidMount() {
        const { channel } = this.props;
        this.faye = new FayeStore(channel);
    }

    componentWillUnmount(): void {
        this.faye.unsubscribe();
    }


    render() {
        return (
            <>
            <ReactEcharts
                style={{width: '100%'}}
                option={this.options}
            />
            <button onClick={this.prev}>Prev</button>
            {this.faye.currentIndex}
            <button onClick={this.next}>Next</button>
            </>
        )
    }

    @action.bound
    prev() {
        this.faye.step(-1);
    }


    @action.bound
    next() {
        this.faye.step(1);
    }

    @computed
    private get options() {
        return {
            title: {
                left: "center",
                text: this.faye.meta.title
            },
            xAxis: {
                type: 'category',
                    data: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
            },
            yAxis: {
                type: 'value'
            },
            series: [{
                data: this.faye.current,
                type: 'line'
            }]
        };
    }
}