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
    private faye: FayeStore<EchartData>;

    componentDidMount() {
        const { channel } = this.props;
        this.faye = new FayeStore<EchartData>(channel);
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
                label: {
                    show: true
                },
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

        const ret = {
            tooltip: {
                trigger: 'axis'
            },
            dataset: {
                dimensions: columns,
                source
            },
            xAxis: {
                type: 'time'
            },
            yAxis,
            series
        };

        console.log(JSON.stringify(ret, null, 2));

        return ret;
    }
}