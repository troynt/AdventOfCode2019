export interface CustomWindow extends Window {
		fayeClient: {
			subscribe: (channel: string, handler: (msg: any) => void) => void;
			publish: (channel: string, data: any) => Promise<void>
		};
}
