import React from "react";
import {FayeStore} from "./stores/FayeStore";

import ReactEcharts from "echarts-for-react";
import {observer} from "mobx-react";
import {computed, observable} from "mobx";
import {EFayeChannel} from "./EFayeChannel";

interface EchartData {
    x: number
}

interface TimeSeriesChartProps {
    channel: EFayeChannel;
}

@observer
export class TimeSeriesChart extends React.Component<TimeSeriesChartProps> {

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
        if( !this.faye ) {
            return null;
        }
        return (
            <ReactEcharts
                style={{width: '100%'}}
                option={this.options}
            />
        )
    }

    @computed
    private get options() {
        const first = this.faye.messages.length > 0 ? this.faye.messages[0] : undefined;
        const columns = first ? Object.keys(first) : [];
        const valueColumns = first ? Object.keys(first).filter(x => x !== 'x') : [];

        const source = this.faye.messages.map(pt => {
            return {
                ...pt,
                x: new Date(pt.x)
            }
        });

        this.faye.messages.map(x => new Date(x['x']));
        const series = valueColumns.map((encode, idx) => {
            return {
                type: 'bar',
                name: encode,
                yAxisIndex: idx,
                encode: {
                    y: encode,
                    x: 'x'
                }
            };
        });


        const yAxis = valueColumns.length === 0 ? {} : valueColumns.map(encode => {
            return {
                type: 'value',
                name: encode
            };
        });

        console.log(this.faye.meta.title)

        const ret = {
            title: {
                left: "center",
                text: this.faye.meta.title
            },
            tooltip: {
                trigger: 'axis'
            },
            dataset: {
                dimensions: columns,
                source
            },
            dataZoom: [{
                type: 'inside'
            }, {
                start: 0,
                end: 10,
                handleIcon: 'M10.7,11.9v-1.3H9.3v1.3c-4.9,0.3-8.8,4.4-8.8,9.4c0,5,3.9,9.1,8.8,9.4v1.3h1.3v-1.3c4.9-0.3,8.8-4.4,8.8-9.4C19.5,16.3,15.6,12.2,10.7,11.9z M13.3,24.4H6.7V23h6.6V24.4z M13.3,19.6H6.7v-1.4h6.6V19.6z',
                handleSize: '80%',
                handleStyle: {
                    color: '#fff',
                    shadowBlur: 3,
                    shadowColor: 'rgba(0, 0, 0, 0.6)',
                    shadowOffsetX: 2,
                    shadowOffsetY: 2
                }
            }],
            xAxis: {
                type: 'time'
            },
            yAxis,
            series
        };

        // console.log(JSON.stringify(ret, null, 2));

        return ret;
    }
}