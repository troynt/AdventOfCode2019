import React from "react";
import {FayeStore} from "./stores/FayeStore";
import {action, observable} from "mobx";
import {observer} from "mobx-react"

interface ChatProps {
}

@observer
export class Chat extends React.Component<ChatProps> {
    @observable
    private faye: FayeStore<string> = new FayeStore("/browser");

    @observable
    private inputText: string = "";

    componentWillUnmount(): void {
        this.faye.unsubscribe();
    }


    render() {
        if( !this.faye ) {
            return null;
        }

        return <div>
            <ul>
                {this.faye.messages.map((x,i) => <li key={i}>{JSON.stringify(x, null, 2)}</li>)}
            </ul>
            <input value={this.inputText} onChange={(e) => this.setInputText(e.target.value)} />
            <button onClick={this.submit}>Submit</button>
        </div>
    }

    @action.bound
    private setInputText(txt: string) {
        this.inputText = txt;
    }

    private submit = () => {
        this.faye.publish(this.inputText);
        this.setInputText("");
    }
}